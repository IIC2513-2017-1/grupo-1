class BetsController < ApplicationController
  include Secured

  before_action :set_bet, only: [:show, :edit, :update, :destroy]
  before_action :logged_in?, only: %i[edit update destroy new make_up_grand create_grand]

  def index
    betss = Bet.includes(:competitors)
    @bets = []
    betss.each do |bet|
      @bets << bet if bet.start_date > DateTime.current
    end
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
    grand = Grand.new(amount: params[:amount].to_i, user_id: current_user.id)
    user = current_user
    unless grand.save && grand.amount <= user.money
      flash[:alert] = 'Grand no fue creado'
      redirect_to root_path
      return
    end
    bets_id = params.select { |c, v| !v.blank? && c.match?(/\A\d+\z/) }.map { |i| i[0] }
    if bets_id.empty?
      return redirect_to root_path, flash: { alert: 'Ingrese alguna seleccion' }
    end
    bets_id.each do |bet_id|
      makeup = MakeUp.new(grand_id: grand.id,
                     bet_id: bet_id.to_i,
                     selection: params[bet_id.to_s])
      unless makeup.save
        flash[:alert] = "Grand no fue creado, problemas en bet #{bet_id}"
        grand.destroy
        return redirect_to root_path
      end
    end
    final_date = DateTime.current - 1.years
    grand.bets.each do |bet|
      final_date = bet.start_date if final_date < bet.start_date
    end
    grand.end_date = final_date
    grand.save
    flash[:success] = 'Grand fue creado con exito'
    user.money -= grand.amount
    user.save
    redirect_to root_path
  end

  def create
    @bet = Bet.new(bet_params.merge(finish: false))
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

  def ganada?(grand)
    grand.bets_per_grand.each do |bet|
      return false if bet.bet.result != bet.selection
    end
    true
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

  private

  def set_bet
    @bet = Bet.find(params[:id])
  end

  def bet_params
    params.require(:bet).permit(:sport, :start_date, :country, :pay_per_tie)
  end

  def get_bets_width(tournament, team, sport, country)
    initial_bets = Bet.all
    bets = []
    initial_bets.each do |bet|
      if !sport.blank?
        bets << bet if bet.sport.match?(/#{Regexp.escape sport}/i)
      elsif !country.blank?
        bets << bet if bet.country.match?(/#{Regexp.escape country}/i)
      elsif !team.blank?
        bet.competitors_per_bet.each do |competitor|
          if competitor.competitor.name.match?(/#{Regexp.escape team}/i)
            bets << bet
            break
          end
        end
      end
    end
    bets
  end
end
