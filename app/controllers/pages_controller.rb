class PagesController < ApplicationController
  include Secured

  before_action :logged_in?

  def home; end

  def bet_list
    @bets = UserBet.includes(:user)
  end

  def friends_bet_list
    @bets = []
    current_user.following.each do |friend|
      friend.user_bets.each do |bet|
        @bets << bet
      end
    end
  end

  # Esto no debiera estar, aqui. Para la entrega 3 lo movemos
  def accept_a_bet
    user = current_user
    bet = UserBet.find(params[:bet_id])
    if bet.gambler_amount > user.money || bet.bet_limit <= 0
      redirect_to bet_list_path,
                  flash: { alert: 'No se pudo ejecutar la apuesta' }
      return
    else
      user.money -= bet.gambler_amount
      bet.bet_limit -= 1
      unless user.save && bet.save
        redirect_to bet_list_path,
                    flash: { alert: 'No se pudo ejecutar la apuesta' }
      end
      user.accepted_bets << bet
      redirect_to bet_list_path,
                  flash: { success: 'Apuesta realizada correctamente' }
    end
  end

  def follow_list
    @users = User.where('username != ?', current_user.username)
  end
end
