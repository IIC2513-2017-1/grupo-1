class UsersController < ApplicationController
  include Secured

  before_action :set_user, only: %i[show edit update destroy]
  before_action :logged_in?, only: %i[show edit update destroy index new_follow_relation]
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
                      notice: "Se ha creado el usuario #{@user.user}" }
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
    unless params.has_key?(:follower_id) && params.has_key?(:followed_id)
      flash[:alert] = 'Debe seleccionar usuario seguidor y seguido'
      return redirect_to follow_path
    end
    follower = User.find(params[:follower_id])
    followed = User.find(params[:followed_id])
    if followed.in?(follower.following) || follower.in?(followed.following)
      flash[:alert] = 'Esta relacion ya existe'
    elsif follower == followed
      flash[:alert] = 'Un usuario no se puede seguir a si mismo'
    else
      follower.following << followed
      followed.following << follower
    end
    redirect_to follow_path
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
