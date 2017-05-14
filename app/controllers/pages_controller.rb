class PagesController < ApplicationController
  include Secured

  before_action :logged_in?

  def home; end

  # eliminar mis apuestas de aqui
  def bet_list
    betss = UserBet.includes(:user)
    @bets = []
    betss.each do |bet|
      @bets << bet if bet.start_date > DateTime.current
    end
  end

  def search_mees_bet
    # Parametros que vuelven como placeholder al form
    @user = params[:user]
    @min_gambler_amount = params[:min_gambler_amount]
    @max_gambler_amount = params[:max_gambler_amount]
    @min_challenger_amount = params[:min_challenger_amount]
    @max_challenger_amount = params[:max_challenger_amount]
    @bets = get_user_bets_with(@user, @min_gambler_amount, @max_gambler_amount,
                               @min_challenger_amount, @max_challenger_amount)
    render 'bet_list'
  end

  def friends_bet_list
    betss = UserBet.joins(:user).joins(
      "INNER JOIN relationships
       ON users.id = followed_id
       WHERE follower_id = #{current_user.id}"
    ).includes(:user)
    @bets = []
    betss.each do |bet|
      @bets << bet if bet.start_date > DateTime.current
    end
  end

  # Esto no debiera estar, aqui. Para la entrega 3 lo movemos
  def accept_a_bet
    user = current_user
    bet = UserBet.find(params[:bet_id])
    if bet.gambler_amount > user.money || bet.bet_limit <= 0 || bet.start_date \
        < DateTime.current
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

  private

  def get_user_bets_with(user_username, min_gambler, max_gambler,
                         min_challenger, max_challenger)
    user = User.find_by(username: user_username)
    initial_bets = []
    bets = []
    initial_bets += if !user.blank?
                      UserBet.where(user_id: user.id).includes(:user)
                    else
                      UserBet.all.includes(:user)
                    end
    initial_bets.each do |bet|
      join = true
      if number?(min_gambler) && bet.gambler_amount < min_gambler.to_i
        join = false
      end
      if number?(max_gambler) && bet.gambler_amount > max_gambler.to_i
        join = false
      end
      if number?(min_challenger) && bet.challenger_amount < min_challenger.to_i
        join = false
      end
      if number?(max_challenger) && bet.challenger_amount > max_challenger.to_i
        join = false
      end
      bets << bet if join == true
    end
    bets
  end
end
