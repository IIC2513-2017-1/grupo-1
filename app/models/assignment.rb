class Assignment < ApplicationRecord
  belongs_to :user_bet, class_name: 'UserBet'
  belongs_to :user, class_name: 'User'
end
