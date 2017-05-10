class UsersController < ApplicationController
  include Secured

  before_action :set_user, only: %i[show edit update destroy]
  before_action :logged_in?, only: %i[show edit update destroy index
                                      new_follow_relation accept_friend]
  def index
    @users = User.all
  end

  def show
    @bets = @user.accepted_bets
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params.merge(money: 10, role: 'gambler'))

    respond_to do |format|
      if @user.save
        format.html { redirect_to new_sessions_path,
                      notice: "Se ha creado el usuario #{@user.username}" }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def new_follow_relation
    unless params.key?(:followed_id)
      flash[:alert] = 'Debe seleccionar usuario a agregar'
      return redirect_to follow_path
    end
    follower = current_user
    followed = User.find(params[:followed_id])
    if followed.in?(follower.following) || follower.in?(followed.following)
      flash[:alert] = 'Esta relacion ya existe'
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
    redirect_to follow_path
  end

  def accept_friend
    unless params.key?(:user_id)
      flash[:alert] = 'Seleccione un usuario'
      redirect_to accept_follow_path
    end
    user = User.find(params[:user_id])
    current_user.pending_relationships.find_by(follower_id: params[:user_id]).destroy
    if params[:accepted]
      current_user.following << user
      user.following << current_user
      flash[:success] = 'Usuario agregado'
    else
      flash[:success] = 'Solicitud de amistad rechazada'
    end
    redirect_to accept_follow_path
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :role, :email,
                                 :password, :password_confirmation,
                                 :name, :lastname, :description, :birthday)
  end
end
