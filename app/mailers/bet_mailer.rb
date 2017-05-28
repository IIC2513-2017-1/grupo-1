class BetMailer < ApplicationMailer
  def grand_accepted_email(user, grand)
    @user = user
    @grand = grand
    mail(to: @user.email, subject: 'Your account has been edited')
  end

  def grand_finished_email(user, grand)
    @user = user
    @grand = grand
    mail(to: @user.email, subject: 'Your account has been edited')
  end
end
