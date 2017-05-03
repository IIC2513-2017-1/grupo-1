# == Schema Information
#
# Table name: make_ups
#
#  id         :integer          not null, primary key
#  bet_id     :integer
#  grand_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  selection  :integer
#

class MyValidator2 < ActiveModel::Validator
  def validate(record)
    apuesta = Bet.where(id: record.bet_id)
    return if apuesta.empty?
    competidores = apuesta.first.competitors
    competidores = competidores.where(id: record.selection)
    if competidores.empty?
      record.errors[:selection] << 'no existe'
    end
  end
end

class MakeUp < ApplicationRecord
  belongs_to :bet, class_name: 'Bet'
  belongs_to :grand, class_name: 'Grand'
  belongs_to :competitor, class_name: 'Competitor'
  validates_with MyValidator2
end
