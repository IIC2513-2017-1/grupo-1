class PagesController < ApplicationController
  include Secured

  before_action :logged_in?

  def home; end

  # eliminar mis apuestas de aqui
  def bet_list
    bets = UserBet.where.not(user_id: current_user.id).includes(:user)
    @bets = []
    bets.each do |bet|
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
    if @bets.empty?
      return redirect_to bet_list_path, flash: { notice: 'No hubo resultados' }
    end
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

  def assignations
    @assignations = current_user.bet_assignations
  end

  # Esto no debiera estar, aqui. Para la entrega 4 lo movemos
  def accept_a_bet
    user = current_user
    bet = UserBet.find(params[:bet_id])
    UserBet.transaction do
      if bet.gambler_amount > user.money || bet.bet_limit <= 0 || bet.start_date \
          < DateTime.current
        redirect_to bet_list_path,
                    flash: { alert: 'No se pudo ejecutar la apuesta' }
        return
      else
        user.money -= bet.gambler_amount
        bet.bet_limit -= 1
        user.save!
        bet.save!
      end
    end
  rescue => invalid
    redirect_to bet_list_path, flash: { alert: invalid }
  else
    user.accepted_bets << bet
    redirect_to bet_list_path,
                flash: { success: 'Apuesta realizada correctamente' }
  end

  def follow_list
    @users = User.where('username != ?', current_user.username)
  end

  private

  def get_user_bets_with(user_username, min_gambler, max_gambler,
                         min_challenger, max_challenger)
    initial_bets = []
    bets = []
    initial_bets += if !user_username.blank?
                      UserBet.joins(:user).where(
                        "username LIKE '%#{user_username}%'"
                      )
                    else
                      UserBet.all.includes(:user)
                    end
    initial_bets.each do |bet|
      next if number?(min_gambler) && bet.gambler_amount < min_gambler.to_i
      next if number?(max_gambler) && bet.gambler_amount > max_gambler.to_i
      if number?(min_challenger) && bet.challenger_amount < min_challenger.to_i
        next
      end
      if number?(max_challenger) && bet.challenger_amount > max_challenger.to_i
        next
      end
      bets << bet
    end
    bets
  end
end
