# == Schema Information
#
# Table name: parts
#
#  id            :integer          not null, primary key
#  competitor_id :integer
#  bet_id        :integer
#  multiplicator :float
#  local         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Part < ApplicationRecord
  belongs_to :bet, class_name: 'Bet'
  belongs_to :competitor, class_name: 'Competitor'
end
