class UserBetsController < ApplicationController
  include Secured

  before_action :set_user_bet, only: [:show, :edit, :update, :destroy]
  before_action :logged_in?
  # GET /user_bets
  # GET /user_bets.json
  def index
    @user_bets = current_user.user_bets
  end

  # GET /user_bets/1
  # GET /user_bets/1.json
  def show; end

  # GET /user_bets/new
  def new
    @user_bet = UserBet.new
  end

  # GET /user_bets/1/edit
  def edit; end

  # POST /user_bets
  # POST /user_bets.json
  def create
    UserBet.transaction do
      @user_bet = UserBet.new(user_bet_params.merge(user_id: current_user.id))
      @user_bet.save!
      save_money(@user_bet)
    end
  rescue => invalid
    flash[:notice] = invalid
    @users = User.all
    render :new
  else
    redirect_to user_user_bet_path(current_user, @user_bet),
                notice: 'User bet was successfully created.'
  end

  # PATCH/PUT /user_bets/1
  # PATCH/PUT /user_bets/1.json
  def update
    respond_to do |format|
      if @user_bet.update(user_bet_params)
        format.html do
          redirect_to user_user_bet_path(current_user, @user_bet),
                      notice: 'User bet was successfully updated.'
        end
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /user_bets/1
  # DELETE /user_bets/1.json
  def destroy
    @user_bet.destroy
    respond_to do |format|
      format.html do
        redirect_to user_user_bets_path(current_user), notice: 'User bet was
                                                       successfully destroyed.'
      end
    end
  end

  private

  def save_money(user_bet)
    user = user_bet.user
    if user.money > user_bet.bet_limit * user_bet.challenger_amount
      user.money -= user_bet.bet_limit * user_bet.challenger_amount
    else
      raise 'No posee el dinerin suficiente'
    end
    user.save
  end

  def set_user_bet
    @user_bet = UserBet.find(params[:id])
    @user = current_user
  end

  def user_bet_params
    params.require(:user_bet).permit(:name, :description, :challenger_amount,
                                     :gambler_amount, :bet_limit, :start_date,
                                     :end_date)
  end

  def return_flash_and_redirect(type, message, path)
    flash[type] = message
    redirect_to path
  end
end
