# == Schema Information
#
# Table name: user_bets
#
#  id                :integer          not null, primary key
#  name              :string
#  description       :string
#  user_id           :integer
#  challenger_amount :integer
#  gambler_amount    :integer
#  bet_limit         :integer
#  start_date        :date
#  end_date          :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class UserBet < ApplicationRecord
  belongs_to :user
end
