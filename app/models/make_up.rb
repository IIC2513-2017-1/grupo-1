# == Schema Information
#
# Table name: make_ups
#
#  id         :integer          not null, primary key
#  bet_id     :integer
#  grand_id   :integer
#  selection  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MakeUp < ApplicationRecord
  belongs_to :bet, class_name: 'Bet'
  belongs_to :grand, class_name: 'Grand'
end
