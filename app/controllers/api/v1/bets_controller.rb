module Api::V1
  class BetsController < ApiController
    before_action :authenticate, only: %i[make_a_grand check_bets]

    def show
      @bet = Bet.find(params[:id])
      @competitors = @bet.competitors_per_bet.map{|x| [@bet.competitors.find(x.competitor_id).name, x.multiplicator]}.compact
      @competitors << ['Empate', @bet.pay_per_tie] if @bet.sport == 'football'
    end

    def index
      # unless current_user.admin?
      #   render json: { errors: 'No tiene permisos' },
      #          status: :access_not_authorized
      # end
      @bets = Bet.all
    end

    def make_a_grand
      unless number?(params[:amount])
        return @status = 'Ingrese un monto'
      end
      bets_id = params.select { |c, v| !v.blank? && c.match?(/\A\d+\z/) }.map { |i| i[0] }
      if bets_id.empty?
        return @status = 'Ingrese alguna seleccion'
      end
      grand = Grand.new(amount: params[:amount].to_i,
                        user_id: @current_user.id,
                        checked: false)
      user = @current_user
      Bet.transaction do
        grand.save!
        user.money -= grand.amount
        user.save!
      end
      @selections = {}
      bets_id.each do |bet_id|
        selection = params[bet_id.to_s]
        @selections[bet_id.to_s] = selection
        makeup = MakeUp.new(grand_id: grand.id,
                            bet_id: bet_id.to_i,
                            selection: selection)
        next if makeup.save
        @status = "Grand no fue creado, problemas en bet #{bet_id}"
        grand.destroy
        return 'meme'
      end
    rescue => invalid
      @status = invalid
    else
      grand.end_date = grand.bets.maximum('start_date')
      grand.save
      grand.bets.each do |bet|
        calculate_multiplicator(bet)
      end
      @status = 'Grand fue creado con exito'
      @grand = grand
      @multiplicador = get_multiplicator grand
      @ganancia = @multiplicador * grand.amount
      @selections
    end

    def check_bets
      if @current_user.role == 'admin'
        bets = Bet.all
        bets.each do |bet|
          next if bet.finish
          next unless bet.end_date < DateTime.current
          bet.finish = true
          bet.result = bet.competitors.order('RANDOM()').first.id
          bet.result = -1 if Random.rand(1..3) == 3
          bet.save!
          bet.grands.each do |grand|
            next unless grand.end_date < DateTime.current_user
            next if grand.finish
            grand.finish = true
            grand.save!
            BetMailer.grand_finished_email(grand.user, grand).deliver_now
            add_money(grand) if ganada?(grand)
          end
        end
        @status = 'Apuestas actualizadas'
      else
        @status = 'Acceso no autorizado'
      end
    end

    private

    def ganada?(grand)
      grand.bets_per_grand.each do |bet|
        return false if bet.bet.result != bet.selection
      end
      true
    end

    def add_money(grand)
      grand.user.money += grand.amount * get_multiplicator(grand)
      grand.user.save!
    end

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

    def get_contents(bets)
      contents = {}
      bets.each do |bet|
        parts = bet.selections.group(:selection_id).count
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

    def get_multiplicator(grand)
      multiplier = 1
      grand.bets_per_grand do |bet|
        selection = bet.selection
        if selection == -1
          mul = bet.pay_per_tie
        else
          mul = bet.bet.competitors_per_bet.find_by(competitor_id:
           selection).multiplicator
        end
        multiplier *= mul
      end
      multiplier
    end
  end
end
