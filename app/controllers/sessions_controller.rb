class SessionsController < ApplicationController
  before_action :revisar_apuestas


  def new; end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      if user.email_confirmed
        session[:user_id] = user.id
        redirect_to bets_path, flash: { success: 'Login successful.' }
      else
        redirect_to(login_path, alert: 'Aun no confirma su email')
      end
    else
      redirect_to(login_path, alert: 'Wrong email or password.')
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'Logout successful.'
  end
end
