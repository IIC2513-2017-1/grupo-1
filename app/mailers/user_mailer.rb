class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @url  = root_url
    mail(to: @user.email, subject: 'Bienvenido a MrMeesBet')
  end

  def account_edited_email(user)
    @user = user
    @url  = user_path(@user)
    mail(to: @user.email, subject: 'Your account has been edited')
  end
end
