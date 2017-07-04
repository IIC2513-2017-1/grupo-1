class UserBetMailer < ApplicationMailer
  def accepted_user_bet_email(user, user_bet)
    @user = user
    @user_bet = user_bet
    mail(to: @user.email, subject: 'Has aceptado una meesbet')
  end

  def finished_user_bet_email(user, user_bet)
    @user = user
    @user_bet = user_bet
    if user_bet.result == 1
      @resultado = 'Gana creador de la apuesta'
    elsif user_bet.result == 2
      @resultado = 'Gana el gambler'
    else
      @resultado = 'Empate'
    end
    @ganancia = 0
    if user.id == user_bet.user_id
      if user_bet.result == 1
        @ganancia = user_bet.bettors.count *
                    (user_bet.challenger_amount + user_bet.gambler_amount)
      elsif user_bet.result == 3
        @ganancia = user_bet.bettors.count * user_bet.challenger_amount
      end
    else
      if user_bet.result == 2
        @ganancia = user_bet.bettors.count *
        (user_bet.challenger_amount + user_bet.gambler_amount)
      elsif user_bet.result == 3
        @ganancia = user_bet.bettors.count * user_bet.gambler_amount
      end
    end
    mail(to: @user.email, subject: 'Apuesta finalizada')
  end
end
