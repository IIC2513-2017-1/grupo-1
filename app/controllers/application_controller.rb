class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :ganada?
  helper_method :get_multiplicator
  helper_method :revisar_apuestas

  def revisar_apuestas
    api = MySportsFeedApi.new()
    bets = Bet.all
    bets.each do |bet|
      next if bet.finish
      next unless bet.end_date < DateTime.current
      bet.finish = true
      if bet.api_id.nil?
        bet.result = bet.competitors.order('RANDOM()').first.id
        if bet.sport == 'football'
          bet.result = -1 if Random.rand(1..3) == 3
        end
      else
        p bet.api_id
        result = api.game_result(bet.api_id.to_i)
        if result == 1
          bet.result = bet.competitors_per_bet.where(local: 1).first.id
        else
          bet.result = bet.competitors_per_bet.where.not(local: 1).first.id
        end
      end
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
    redirect_to root_path, flash: { success: 'Apuestas actualizadas' }
  end

  protected

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

  def add_money(grand)
    grand.user.money += grand.amount * get_multiplicator(grand)
    grand.user.save!
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = session.key?(:user_id) && User.find(session[:user_id])
  end

  def number?(string)
    true if Integer(string)
  rescue
    false
  end

  def accept_user_bet(user, bet)
    UserBet.transaction do
      if bet.gambler_amount > user.money || bet.bet_limit <= 0 \
            || bet.start_date < DateTime.current
        return :alert, 'No se pudo ejecutar la apuesta'
      else
        user.money -= bet.gambler_amount
        bet.bet_limit -= 1
        user.save!
        bet.save!
      end
    end
  rescue => invalid
    return :alert, invalid
  else
    user.accepted_bets << bet
    return :success, 'Apuesta realizada correctamente'
  end
end
