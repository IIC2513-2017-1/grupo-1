class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :revisar_apuestas

  helper_method :current_user

  protected

  def revisar_apuestas
    bets = Bet.all
    bets.each do |bet|
      unless bet.finish
        if bet.end_date < DateTime.current
          bet.finish = true
          bet.result = bet.competitors.order('RANDOM()').first.id
          bet.save!
          bet.grands.each do |grand|
            if grand.end_date < DateTime.current_user
              unless grand.finish
                grand.finish = true
                grand.save!
                add_money(grand) if ganada?(grand)
              end
            end
          end
        end
      end
    end
  end

  def add_money(grand)
    grand.user.money += grand.amount * get_multiplicator(grand)
    grand.user.save!
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = session.key?(:user_id) && User.find(session[:user_id])
  end

  def number?(string)
    true if Integer(string)
  rescue
    false
  end
end
