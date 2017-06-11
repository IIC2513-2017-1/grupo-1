class UsersController < ApplicationController
  include Secured

  before_action :set_user, only: %i[show edit update destroy
                                    record notifications]
  before_action :logged_in?, only: %i[show edit update destroy index
                                      new_follow_relation accept_friend]

  def index
    unless current_user.admin?
      return redirect_to root_path, flash: { alert: 'Acceso denegado' }
    end
    @users = User.all
  end

  def show
    @bets = @user.accepted_bets
  end

  def new
    if current_user
      return redirect_to root_path, flash: { alert: 'Acceso denegado' }
    end
    @user = User.new
  end

  def edit
    return if @user == current_user
    redirect_to user_path(@user), flash: { alert: 'Acceso denegado' }
  end

  def accept_deny_notifications
    bet = UserBet.find(params[:bet_id])
    if params[:aceptar] == 'true' && bet
      flash_type, flash_msg = accept_user_bet(current_user, bet)
      return redirect_to bet_list_path, flash: { flash_type => flash_msg }
    end
    current_user.notifications.delete(bet) if bet
    redirect_to notifications_user_path(current_user)
  end

  def manage_money
    @user = current_user
    money_in = params[:money_in].to_i
    money_out = params[:money_out].to_i
    @user.money += money_in - money_out
    if @user.save
      flash[:success] = 'Dinerín actualizado correctamente'
    else
      flash[:alert] = 'No se pudo realizar el movimiento de dinerín'
    end
    redirect_to @user
  end

  def create
    @user = User.new(user_params.merge(money: 100, role: 'gambler'))
    User.transaction do
      @user.save
      UserMailer.registration_confirmation(@user).deliver_now
    end
  rescue => invalid
    flash[:notice] = invalid
    @user = User.new
    render :new
  else
    redirect_to login_path, flash: {
      success: 'Porfavor confirme su email antes de continuar'
    }
  end

  def update
    actual_password = params[:user][:actual_password]
    unless @user.authenticate(actual_password)
      return redirect_to edit_user_path,
                         flash: { alert: 'Ingrese contraseña actual' }
    end

    # Considerar solo inputs no vacios
    new_params = user_params.reject { |_, v| v.blank? }

    # Si ingresa un mail nuevo, debe ser junto con la confirmacion
    unless new_params.key?('email') && new_params['email'] == @user.email
      if new_params.key?('email') ^ new_params.key?('email_confirmation')
        return redirect_to edit_user_path, flash: {
          alert: 'Debe ingresar email junto con la confirmacion'
        }
      end
    end

    # Password nueva debe ir con confirmacion
    if new_params.key?('password') ^ new_params.key?('password_confirmation')
      return redirect_to edit_user_path, flash: {
        alert: 'Debe ingresar contraseña junto con la confirmacion'
      }
    end
    if @user.update(new_params)
      UserMailer.account_edited_email(@user).deliver_now
      redirect_to @user, flash: {
        success: 'Usuario fue editado correctamente'
      }
    else
      redirect_to edit_user_path
    end
  end

  def search
    @users = User.where("username LIKE '%#{params[:user]}%'")
    if @users.empty?
      return redirect_to users_path, flash: { notice: 'No hubo resultados' }
    end
    render 'index'
  end

  # Falta testear permisos
  def new_follow_relation
    unless params.key?(:followed_id)
      return redirect_to follow_path,
                         flash: { alert: 'Debe seleccionar usuario seguido' }
    end
    follower = current_user
    followed = User.find(params[:followed_id])
    if followed.in?(follower.following) || follower.in?(followed.following)
      flash[:notice] = "Ya sigues al usuario #{followed.username}"
    elsif follower == followed
      flash[:alert] = 'Un usuario no se puede seguir a si mismo'
    elsif follower.in?(followed.demands)
      flash[:alert] = 'La solicitud está pendiente'
    elsif followed.in?(follower.demands)
      flash[:alert] = "El usuario #{followed.username} ya le envió una solicitud"
    else
      followed.demands << follower
      flash[:success] = 'Solicitud enviada'
    end
    redirect_to friends_path
  end

  # Falta testear permisos
  def accept_friend
    unless params.key?(:user_id)
      flash[:alert] = 'Seleccione un usuario'
      redirect_to accept_follow_path
    end
    user = User.find(params[:user_id])
    current_user.pending_relationships.find_by(followed_id: params[:user_id]).destroy
    if params[:accepted]
      current_user.following << user
      user.following << current_user
      flash[:success] = 'Usuario agregado'
    else
      flash[:success] = 'Solicitud de amistad rechazada'
    end
    redirect_to friends_path
  end

  def record
    unless current_user == @user
      redirect_to root_path, flash: { alert: 'Acceso no autorizado' }
    end
    @grands = @user.grands.where(
      checked: true
    ).includes(bets: :competitors)
    user_bets = @user.user_bets
    accepted_user_bets = @user.accepted_bets.includes(:user)
    @user_bets = []
    user_bets.each do |user_bet|
      @user_bets << user_bet unless user_bet.result.nil?
    end
    @accepted_user_bets = []
    accepted_user_bets.each do |user_bet|
      @accepted_user_bets << user_bet unless user_bet.result.nil?
    end
    respond_to do |format|
      format.html
      format.xls
    end
  end

  def notifications
    unless current_user == @user
      return redirect_to root_path, flash: { alert: 'Access denied' }
    end
    @notifications = @user.notifications
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      flash[:success] = 'Bienvenido a MrMeesBet, tu email fue confirmado,
                        por favor ingresa a la aplicacion para continuar.'
      redirect_to login_path
    else
      flash[:error] = 'Perdon, usuario no existe.'
      redirect_to root_url
    end
  end

  def destroy
    username = @user.username
    @user.destroy
    respond_to do |format|
      format.html do
        redirect_to users_url, flash: {
          success: "Usuario #{username} fue eliminado correctamente"
        }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :email_confirmation,
                                 :password, :password_confirmation, :avatar,
                                 :name, :lastname, :description, :birthday)
  end
end
