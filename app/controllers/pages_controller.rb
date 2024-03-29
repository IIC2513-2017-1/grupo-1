class PagesController < ApplicationController
  include Secured

  before_action :logged_in?

  # eliminar mis apuestas de aqui
  def bet_list
    bets = UserBet.where.not(
      user_id: current_user.id
    ).includes(:user)
    @bets = []
    bets.each do |bet|
      mostra = true
      p 'hola'
      if bet.exclusive && !current_user.admin?
        p 'chao'
        mostra = false unless bet.user.following.include?(current_user)
      end
      p bet.checked
      p bet.start_date > DateTime.current
      @bets << bet if bet.start_date > DateTime.current && bet.checked && mostra
    end
  end

  def accept_friends
    @users = User.where.not(username: current_user.username).where.not(username: current_user.following.select(:username))
    @requests = current_user.demands
  end

  def search_mees_bet
    # Parametros que vuelven como placeholder al form
    @searched_user = params[:user]
    @min_gambler_amount = params[:min_gambler_amount]
    @max_gambler_amount = params[:max_gambler_amount]
    @min_challenger_amount = params[:min_challenger_amount]
    @max_challenger_amount = params[:max_challenger_amount]
    @friends = params[:friends]
    @bets = get_user_bets_with(@searched_user, @min_gambler_amount,
                               @max_gambler_amount, @min_challenger_amount,
                               @max_challenger_amount, @friends)
    if @bets.empty?
      return redirect_to bet_list_path, flash: { notice: 'No hubo resultados' }
    end
    render 'bet_list'
  end

  def assignations
    @pending_assignations = current_user.bet_assignations.where(checked: nil)
    result_assignations = current_user.bet_assignations
                                      .where(result: nil).where(checked: true)
    @result_assignations = []
    result_assignations.each do |assignation|
      @result_assignations << assignation if assignation.end_date <
                                             DateTime.current
    end
  end

  def accept_a_bet
    user = current_user
    @bet = UserBet.find(params[:bet_id])
    @result, msg = accept_user_bet(user, @bet)
    respond_to do |format|
      format.html do
        redirect_to bet_list_path, flash: { @result => msg }
      end
      format.json
    end
  end

  private

  def get_user_bets_with(user_username, min_gambler, max_gambler,
                         min_challenger, max_challenger, friends)
    bets = []
    initial_bets = if friends
                     UserBet.joins(:user).joins(
                       "INNER JOIN relationships
                        ON users.id = followed_id
                        WHERE follower_id = #{current_user.id}"
                     )
                   else
                     UserBet.all
                   end
    unless user_username.blank?
      initial_bets = UserBet.joins(:user).where(
        "username LIKE '%#{user_username}%'"
      ).where(id: initial_bets)
    end
    initial_bets = initial_bets.includes(:user)
    initial_bets.each do |bet|
      next if number?(min_gambler) && bet.gambler_amount < min_gambler.to_i
      next if number?(max_gambler) && bet.gambler_amount > max_gambler.to_i
      if number?(min_challenger) && bet.challenger_amount < min_challenger.to_i
        next
      end
      if number?(max_challenger) && bet.challenger_amount > max_challenger.to_i
        next
      end
      bets << bet if bet.start_date > DateTime.current && bet.checked
    end
    bets
  end
end
