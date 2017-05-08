class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to bets_path, flash: { success: 'Login successful.' }
    else
      redirect_to(new_sessions_path, alert: 'Wrong email or password.')
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'Logout successful.'
  end
end
