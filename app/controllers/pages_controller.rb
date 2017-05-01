class PagesController < ApplicationController
  def home; end

  def bet_list
    @bets = UserBet.all
    @users = User.all
  end

  # Esto no debiera estar, aqui. Para la entrega 3 lo movemos
  def accept_a_bet
    user = User.find(params[:user_id])
    bet = UserBet.find(params[:bet_id])
    if bet.gambler_amount > user.money || bet.bet_limit <= 0
      redirect_to bet_list_path
      flash[:alert] = 'No se pudo ejecutar la apuesta'
      return
    else
      user.money -= bet.gambler_amount
      bet.bet_limit -= 1
      unless user.save && bet.save
        flash[:alert] = 'No se pudo ejecutar la apuesta'
        redirect_to bet_list_path
      end
      p 'pase por aqui'
      p user.accepted_bets
      user.accepted_bets << bet
      p user.accepted_bets
      redirect_to bet_list_path
    end
  end

  def follow_list
    @users = User.all
  end
end
