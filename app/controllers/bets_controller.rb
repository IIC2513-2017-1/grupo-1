class BetsController < ApplicationController
  include Secured

  before_action :set_bet, only: %i[show edit update destroy]
  before_action :logged_in?, only: %i[edit update destroy
                                      new make_up_grand create_grand]
  helper_method :empate?
  helper_method :get_percentage

  def index
    @bets = Bet.current_bets.order(:start_date).includes(
      :competitors, :selections, :competitors_per_bet
    )
    @contents = get_contents(@bets)
  end

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
    @bets = @bets
    @contents = get_contents(@bets)
    render 'index'
  end

  def set_amount
    previo = params[:previous_mul].split(' ')[-1].to_f
    amount = params[:amount].to_f
    @wining = previo * amount
    respond_to :json
  end

  def add_bet
    @bet = Bet.find_by_id(params[:bet_id])
    @delete = false
    previo = params[:previous_mul].split(' ')[-1].to_f
    amount = params[:amount].to_f
    if params[:previous].blank?
      @multiplicator = previo
    elsif params[:previous].to_i == -1
      @multiplicator = previo / @bet.pay_per_tie
    else
      @multiplicator = previo / @bet.competitors_per_bet.find_by_competitor_id(
        params[:previous].to_i
      ).multiplicator
    end
    if params[:competitor].blank?
      @competitor = nil
      @delete = true
    elsif params[:competitor].to_i == -1
      @competitor = 'Empate'
      @multiplicator = previo * @bet.pay_per_tie
    else
      @competitor = Competitor.find(params[:competitor].to_i).name
      @multiplicator = previo * @bet.competitors_per_bet.find_by_competitor_id(
        params[:competitor].to_i
      ).multiplicator
    end
    @wining = amount * @multiplicator
    respond_to :json
  end

  def create_grand
    unless number?(params[:amount])
      return redirect_to root_path, flash: { alert: 'Ingrese un monto' }
    end
    bets_id = params.select { |c, v| !v.blank? && c.match?(/\A\d+\z/) }.map { |i| i[0] }
    if bets_id.empty?
      return redirect_to root_path, flash: { alert: 'Ingrese alguna seleccion' }
    end
    grand = Grand.new(amount: params[:amount].to_i,
                      user_id: current_user.id,
                      checked: false)
    user = current_user
    Bet.transaction do
      grand.save!
      user.money -= grand.amount
      user.save!
    end
    bets_id.each do |bet_id|
      makeup = MakeUp.new(grand_id: grand.id,
                          bet_id: bet_id.to_i,
                          selection: params[bet_id.to_s])
      next if makeup.save
      flash[:alert] = "Grand no fue creado, problemas en bet #{bet_id}"
      grand.destroy
      return redirect_to root_path
    end
  rescue => invalid
    redirect_to bet_list_path, flash: { alert: invalid }
  else
    grand.end_date = grand.bets.maximum('start_date')
    grand.save
    grand.bets.each do |bet|
      calculate_multiplicator(bet)
    end
    redirect_to root_path, flash: { success: 'Grand fue creado con exito' }
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

  def add_api_matchs
    api = MySportsFeedApi.new
    today = Date.today
    days = params[:days].to_i
    days.times do
      month = today.month.to_s
      month = "0#{month}" if month.length == 1
      day = today.day.to_s
      day = "0#{day}" if month.length == 1
      matchs = api.daily_game_schedule("2016#{month}#{day}")
      matchs.each do |match|
        hour = match['time'].sub('PM', '').sub('AM', '').split(':')
        start = DateTime.new(2017, month.to_i, day.to_i,
                             hour[0].to_i + 11, hour[1].to_i, 0)
        bet = Bet.new(
          country: 'US',
          sport: 'baseball',
          start_date: start,
          end_date: start + 3.hours,
          finish: false,
          pay_per_tie: 2,
          result: nil,
          api_id: match['ID'].to_i,
          tournament: 'mlb'
        )
        bet.save
        Part.create(
          local: 1,
          multiplicator: 1 + Random.rand(0..10) / 10.0,
          bet_id: bet.id,
          competitor_id: Competitor.find_by_api_id(match['homeTeam']['ID']).id
        )
        Part.create(
          local: 0,
          multiplicator: 1 + Random.rand(0..10) / 10.0,
          bet_id: bet.id,
          competitor_id: Competitor.find_by_api_id(match['awayTeam']['ID']).id
        )
      end
      today += 1.day
    end
  end

  private

  def calculate_multiplicator(bet)
    total = bet.selections.length
    options = bet.competitors.length + empate?(bet)
    if total < 2
      bet.pay_per_tie = (options + 1) / 2
      bet.competitors_per_bet.each do |competitor|
        competitor.multiplicator = (options + 1) / 2
        competitor.save
      end
    elsif total < 5
      return
    else
      general = {}
      general[-1] = 1
      bet.competitors.each do |c|
        general[c.id] = 0
      end
      general.update(bet.selections.group(:selection).length)
      general[-1] = 1 if general[-1].zero?
      bet.pay_per_tie = get_mul(general[-1], total) if empate?(bet) == 1
      bet.competitors_per_bet.each do |competitor|
        general[competitor.competitor_id] = 1 if general[competitor.competitor_id].zero?
        competitor.multiplicator = get_mul(general[competitor.competitor_id], total)
        competitor.save
      end
    end
    bet.save
  end

  def empate?(bet)
    sport = bet.sport
    return 1 if sport == 'football'
    0
  end

  def get_percentage(bet, competitor, total, participate)
    participate = 0 if participate.nil?
    total = 1 if total.zero?
    if competitor == -1
      multiplicator = bet.pay_per_tie
    else
      multiplicator = bet.competitors_per_bet.find_by_competitor_id(
        competitor
      ).multiplicator
    end
    "#{participate * 100 / total}% - x#{multiplicator}"
  end

  def set_bet
    @bet = Bet.find(params[:id])
  end

  def bet_params
    params.require(:bet).permit(:sport, :start_date, :country, :pay_per_tie)
  end

  def get_mul(porcentaje, total)
    numero = 1.05 * total / (porcentaje + total / 5)
    [1.05, numero].max.round(2)
  end

  def get_bets_width(tournament, team, sport, country)
    initial_bets = Bet.current_bets
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

  def get_contents(bets)
    contents = {}
    bets.each do |bet|
      parts = bet.selections.group(:selection).count
      content = []
      total = bet.selections.count
      content << ["Empate #{get_percentage(bet, -1, total, parts[-1])}", -1] if empate?(bet) == 1
      bet.competitors.each do |competitor|
        content << ["#{competitor.name} #{get_percentage(bet, competitor.id, total, parts[competitor.id])}",
                    competitor.id]
      end
      contents[bet.id] = content
    end
    contents
  end
end
