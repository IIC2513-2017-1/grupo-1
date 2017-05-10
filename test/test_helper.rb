ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  fixtures :all

  def log_in(user, password)
    post login_url, params: { session: { email: user.email,
                                         password: password }
                                       }
  end

  def get_multiplicator(grand)
    multiplier = 1
    grand.bets_per_grand.each do |bet|
      selection = bet.selection
      mul = bet.bet.competitors_per_bet.find_by(competitor_id:
       selection).multiplicator
      multiplier *= mul
    end
    multiplier
  end
end
