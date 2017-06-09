# == Schema Information
#
# Table name: assignments
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  user_bet_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Assignment < ApplicationRecord
  belongs_to :user_bet, class_name: 'UserBet'
  belongs_to :user, class_name: 'User'
end
