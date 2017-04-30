class PagesController < ApplicationController
  def home; end

  def bet_list
    @bets = UserBet.all
    @users = User.all
  end

  def accept_a_bet
    user = User.find(params[:user_id])
    bet = UserBet.find(params[:bet_id])
    user.accepted_bets << bet
    redirect_to root_path
  end

  def follow_list
    @users = User.all
  end
end
