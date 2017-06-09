class PagesController < ApplicationController
  include Secured

  before_action :logged_in?

  def home; end

  # eliminar mis apuestas de aqui
  def bet_list
    bets = UserBet.where.not(
      user_id: current_user.id
    ).where.not(
      id: User.find_by_email('j123@uc.cl').accepted_bets.select(:id)
    ).includes(:user)
    @bets = []
    bets.each do |bet|
      @bets << bet if bet.start_date > DateTime.current && bet.checked
    end
  end

  def search_mees_bet
    # Parametros que vuelven como placeholder al form
    @searched_user = params[:user]
    @min_gambler_amount = params[:min_gambler_amount]
    @max_gambler_amount = params[:max_gambler_amount]
    @min_challenger_amount = params[:min_challenger_amount]
    @max_challenger_amount = params[:max_challenger_amount]
    @bets = get_user_bets_with(@searched_user, @min_gambler_amount,
                               @max_gambler_amount, @min_challenger_amount,
                               @max_challenger_amount)
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
    @user = current_user
    betss.each do |bet|
      @bets << bet if bet.start_date > DateTime.current && bet.checked
    end
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

  def follow_list
    @users = User.where.not(username: current_user.username)
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
