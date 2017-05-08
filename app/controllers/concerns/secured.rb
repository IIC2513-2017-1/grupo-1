module Secured
  extend ActiveSupport::Concern


  def logged_in?
    redirect_to(new_sessions_path, notice: 'inicie sesión primero') unless current_user
  end
end
