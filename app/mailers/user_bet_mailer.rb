class UserBetMailer < ApplicationMailer
  def accepted_user_bet_email(user, user_bet)
    @user = user
    @user_bet = user_bet
    mail(to: @user.email, subject: 'Your account has been edited')
  end

  def finished_user_bet_email(user, user_bet)
    @user = user
    @user_bet = user_bet
    mail(to: @user.email, subject: 'Your account has been edited')
  end
end
