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

class MyValidator1 < ActiveModel::Validator
  def validate(record)
    usuario = User.where(id: record.user_id)
    if not usuario.empty?
      if record.challenger_amount * record.bet_limit > usuario.first.money 
        record.errors[:challenger_amount] << 'Debes tener el dinerin para apostar'
      end
    end
    if record.start_date > record.end_date
      record.errors[:end_date] << 'Ingrese fechas con sentido'
    end
  end
end



class UserBet < ApplicationRecord
  include ActiveModel::Validations
  belongs_to :user
  validates :name, presence: true,
  				length: { minimum: 7, maximum: 100 }
  validates :description, presence: true,
  						length: {maximum: 300}
  validates :challenger_amount, numericality: {only_integer: true, greater_than: 0} 
  validates :gambler_amount, numericality: {only_integer: true, greater_than: 0} 
  validates :bet_limit, numericality: {only_integer: true, greater_than: 0} 
  validates_with MyValidator1
  validates :start_date, inclusion: { in: (DateTime.current + 2.hours..DateTime.current + 1.years) }

end