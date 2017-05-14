class BetsController < ApplicationController
  include Secured

  before_action :set_bet, only: %i[show edit update destroy]
  before_action :logged_in?, only: %i[edit update destroy
                                      new make_up_grand create_grand]

  def index
    @bets = Bet.includes(:competitors)
  end

  def show; end

  def new
    @bet = Bet.new
  end

  def edit; end

  def search
    @tournament = params[:tournament]
    @team = params[:team]
    @sport = params[:sport]
    @country = params[:country]
    @bets = get_bets_width(@tournament, @team, @sport, @country)
    if @bets.empty?
      return redirect_to root_path,
                         flash: { notice: 'No se encontraron resultados' }
    end
    render 'index'
  end

  def create_grand
    unless number?(params[:amount])
      return redirect_to root_path, flash: { alert: 'Ingrese un monto' }
    end
    bets_id = params.select { |c, v| !v.blank? && c.match?(/\A\d+\z/) }.map { |i| i[0] }
    if bets_id.empty?
      return redirect_to root_path, flash: { alert: 'Ingrese alguna seleccion' }
    end
    grand = Grand.new(amount: params[:amount].to_i, user_id: current_user.id)
    user = current_user
    Bet.transaction do
      grand.save!
      user.money -= grand.amount
      user.save!
    end
    bets_id.each do |bet_id|
      MakeUp.create!(grand_id: grand.id,
                     bet_id: bet_id.to_i,
                     selection: params[bet_id.to_s])
    end
  rescue => invalid
    redirect_to bet_list_path, flash: { alert: invalid }
  else
    grand.end_date = grand.bets.maximum('start_date')
    grand.save
    redirect_to root_path, flash: { success: 'Grand fue creado con exito' }
  end

  def create
    @bet = Bet.new(bet_params)
    respond_to do |format|
      if @bet.save
        format.html do
          redirect_to @bet, notice: 'Bet was successfully created.'
        end
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @bet.update(bet_params)
        format.html do
          redirect_to @bet, notice: 'Bet was successfully updated.'
        end
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @bet.destroy
    respond_to do |format|
      format.html do
        redirect_to bets_url, notice: 'Bet was successfully destroyed.'
      end
    end
  end

  private

  def set_bet
    @bet = Bet.find(params[:id])
  end

  def bet_params
    params.require(:bet).permit(:sport, :start_date, :country,
                                :pay_per_tie, :tournament)
  end

  def get_multiplicator(grand)
    multiplier = 1
    grand.bets_per_grand do |bet|
      selection = bet.selection
      mul = bet.bet.competitors_per_bet.find_by(competitor_id:
       selection).multiplicator
      multiplier *= mul
    end
    multiplier
  end

  def get_bets_width(tournament, team, sport, country)
    initial_bets = Bet.all
    bets = []
    initial_bets.each do |bet|
      unless sport.blank?
        next unless bet.sport.match?(/#{Regexp.escape sport}/i)
      end
      unless country.blank?
        next unless bet.country.match?(/#{Regexp.escape country}/i)
      end
      unless tournament.blank?
        next unless bet.tournament.match?(/#{Regexp.escape tournament}/i)
      end
      unless team.blank?
        found_competitor = false
        bet.competitors_per_bet.each do |competitor|
          if competitor.competitor.name.match?(/#{Regexp.escape team}/i)
            found_competitor = true
            break
          end
        end
        next unless found_competitor
      end
      bets << bet
    end
    bets
  end
end
