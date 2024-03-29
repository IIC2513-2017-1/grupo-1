class UserBetsController < ApplicationController
  include Secured

  before_action :set_user_bet, only: %i[show edit update destroy invite]
  before_action :logged_in?
  before_action :authenticate_user, only: %i[edit update
                                             invite index]
  before_action :authenticate_user_or_admin, only: %i[show destroy]

  def index
    @user = User.find(params[:user_id])
    if current_user != @user && !current_user.admin?
      redirect_to root_path, flash: { alert: 'Acceso no autorizado' }
    end
    @user_bets = @user.user_bets
  end

  def show; end

  def new
    @user = User.find(params[:user_id])
    unless current_user == @user
      return redirect_to root_path, flash: { alert: 'Access denied' }
    end
    @user_bet = UserBet.new
  end

  def edit
    return if @user == current_user
    redirect_to user_user_bet_path(@user, @user_bet),
                flash: { alert: 'Access denied' }
  end

  def invite
    friend = User.find(params[:friend])
    unless friend
      return redirect_to user_user_bet_path(@user, @user_bet), flash: {
        alert: 'No se ha podido realizar la invitación'
      }
    end
    if friend.notifications.find_by(id: @user_bet.id)
      return redirect_to user_user_bet_path(@user, @user_bet), flash: {
        alert: 'Ya ha enviado una notificación a este usuario'
      }
    end
    friend.notifications << @user_bet
    redirect_to user_user_bet_path(@user, @user_bet), flash: {
      success: "Se ha invitado correctamente al usuario #{friend.username}"
    }
  end

  def create
    UserBet.transaction do
      privado = false
      privado = true if user_bet_params[:exclusive] == '1'
      @user_bet = UserBet.new(user_bet_params.merge(user_id: current_user.id,
                                                    exclusive: privado))
      @user_bet.save!
      save_money(@user_bet)
    end
  rescue => invalid
    flash[:notice] = invalid
    @users = User.all
    render :new
  else
    admin = User.where(role: 'admin').order('RANDOM()').first
    admin.bet_assignations << @user_bet
    redirect_to user_user_bet_path(current_user, @user_bet),
                flash: { success: 'User bet was successfully created.' }
  end

  def update
    respond_to do |format|
      if @user_bet.update(user_bet_params)
        format.html do
          redirect_to user_user_bet_path(current_user, @user_bet),
                      flash: { success: 'User bet was successfully updated.' }
        end
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    if @user_bet.start_date > DateTime.current
      return redirect_to user_user_bet_path(current_user, @user_bet),
                         flash: { alert: 'No se puede eliminar una
                                          apuesta cuyo evento ya inició' }
    end
    @user_bet.user.money += @user_bet.bet_limit * @user_bet.challenger_amount
    @user_bet.bettors.each do |bettor|
      @user_bet.user.money += @user_bet.challenger_amount
      bettor.money += @user_bet.gambler_amount
      bettor.save
    end
    @user_bet.user.save
    @user_bet.destroy
    respond_to do |format|
      format.html do
        redirect_to user_user_bets_path(current_user),
                    flash: { success: 'User bet was successfully destroyed.' }
      end
    end
  end

  def obtener_resultado
    @user_bet = UserBet.find(params[:bet_id])
    @user = @user_bet.user
    @user_bet.result = params[:result].to_i
    if @user_bet.save
      repartir @user_bet
      UserBetMailer.finished_user_bet_email(@user, @user_bet).deliver_now
      @user_bet.bettors.each do |bettor|
        UserBetMailer.finished_user_bet_email(bettor, @user_bet).deliver_now
      end
    else
      flash[:alert] = 'Ocurrió un error inesperado'
    end
    redirect_to assignations_path
  end

  def aceptar_rechazar
    bet = UserBet.find(params[:bet_id])
    if params[:aceptar] == 'true'
      bet.checked = true
      flash.now[:success] = "Apuesta #{bet.id} aceptada"
    else
      bet.checked = false
      flash.now[:success] = "Apuesta #{bet.id} rechazada"
    end
    bet.save
    redirect_to assignations_path
  end

  private

  def authenticate_user
    @user = User.find(params[:user_id])
    return if @user == current_user
    redirect_to root_path, flash: { alert: 'acceso no autorizado' }
  end

  def authenticate_user_or_admin
    @user = User.find(params[:user_id])
    return if @user == current_user || current_user.admin?
    redirect_to root_path, flash: { alert: 'acceso no autorizado' }
  end

  def repartir(user_bet)
    user_bet.user.money += user_bet.bet_limit * user_bet.challenger_amount
    user_bet.bettors.each do |bettor|
      if user_bet.result == 1
        user_bet.user.money += user_bet.challenger_amount +
                               user_bet.gambler_amount
      elsif user_bet.result == 2
        bettor.money += user_bet.challenger_amount + user_bet.gambler_amount
        bettor.save
      else
        bettor.money += user_bet.gambler_amount
        user_bet.user.money += user_bet.challenger_amount
        bettor.save
      end
    end
    user_bet.user.save
  end

  def save_money(user_bet)
    user = user_bet.user
    if user.money < user_bet.bet_limit * user_bet.challenger_amount
      raise 'No posee el dinerin suficiente'
    end
    user.money -= user_bet.bet_limit * user_bet.challenger_amount
    user.save
  end

  def set_user_bet
    @user_bet = UserBet.find(params[:id])
    @user = User.find(params[:user_id])
  end

  def user_bet_params
    params.require(:user_bet).permit(:name, :description, :challenger_amount,
                                     :gambler_amount, :bet_limit, :start_date,
                                     :end_date, :exclusive)
  end
end
