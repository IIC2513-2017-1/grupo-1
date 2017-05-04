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
#  start_date        :datetime
#  end_date          :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class MyValidator1 < ActiveModel::Validator
  def validate(record)
    if record.start_date > record.end_date
      record.errors[:end_date] << 'Ingrese fechas con sentido'
    end
    unless DateTime.current + 2.hours < record.start_date &&
           record.start_date < DateTime.current + 1.years
      if record.created_at.nil?
        record.errors[:start_date] << 'debe ser dentro de dos horas como mínimo'
      elsif record.created_at + 2.hours > record.start_date
        record.errors[:start_date] << 'debe ser dentro de dos horas como mínimo'
      end
    end
    usuario = User.find(record.user_id)
    record.errors[:usuario] << 'No definido' if usuario.nil?
    if record.challenger_amount.nil?
      record.errors[:challenger_amount] << 'No definido'
    end
    record.errors[:bet_limit] << 'No definido' if record.bet_limit.nil?
    if usuario.money < record.challenger_amount * record.bet_limit &&
       record.created_at.nil?
      record.errors[:dinerin] << 'insuficiente'
    end
  end
end

class UserBet < ApplicationRecord
  has_and_belongs_to_many :bettors,
                          class_name: 'User',
                          join_table: :user_user_bets
  include ActiveModel::Validations
  belongs_to :user
  validates :name, presence: true, length: { minimum: 7, maximum: 100 }
  validates :description, presence: true, length: { maximum: 300 }
  validates :challenger_amount, presence: true,
                                numericality: { only_integer: true,
                                                greater_than: 0 }
  validates :gambler_amount, presence: true,
                             numericality: { only_integer: true,
                                             greater_than: 0 }
  validates :bet_limit, presence: true,
                        numericality: { only_integer: true, greater_than: -1 }
  validates_with MyValidator1

end
