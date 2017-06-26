module Api::V1
  class UsersController < ApiController
    before_action :authenticate

    def show
      @user = User.includes(:user_bets).find(params[:id])
    end

    def index
      unless @current_user.admin?
        render json: { errors: 'No tiene permisos' },
               status: :access_not_authorized
      end
      @users = User.all
    end
  end
end
