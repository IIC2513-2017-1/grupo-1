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
    record.errors[:bet_id] << 'no existe' if apuesta.empty?
    competidores = apuesta.first.competitors
    competidores = competidores.where(id: record.selection)
    record.errors[:selection] << 'no existe' if competidores.empty?
    record.errors[:apuesta] << 'pasada' if apuesta.first.start_date < DateTime.current
  end
end

class MakeUp < ApplicationRecord
  belongs_to :bet, class_name: 'Bet'
  belongs_to :grand, class_name: 'Grand'
  validates :bet_id, uniqueness: { scope: :grand_id }
  validates_with MyValidator2
end
