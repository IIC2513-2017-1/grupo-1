class BetMailer < ApplicationMailer
  def grand_accepted_email(user, grand)
    @user = user
    @grand = grand
    @bets = @grand.bets_per_grand
    mail(to: @user.email, subject: 'Haz realizado una apuesta')
  end

  def grand_finished_email(user, grand)
    @user = user
    @grand = grand
    @plata = 0
    @plata = get_multiplicator(@grand) * @grand.amount if ganada?(@grand)
    @bets = @grand.bets_per_grand
    mail(to: @user.email, subject: 'Apuesta finalizada')
  end
end
