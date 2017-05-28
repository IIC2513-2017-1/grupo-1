class UserMailer < ApplicationMailer
  def registration_confirmation(user)
    @user = user
    @url  = root_url
    mail(to: @user.email, subject: 'Bienvenido a MrMeesBet')
  end

  def account_edited_email(user)
    @user = user
    @url  = user_url(@user)
    mail(to: @user.email, subject: 'Your account has been edited')
  end
end
