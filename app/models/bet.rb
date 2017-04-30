class Bet < ApplicationRecord
  has_many :competitors_per_bet, class_name: 'Part',
                            foreign_key: 'bet_id',
                            dependent: :destroy
  has_many :competitors, through: :competitors_per_bet, source: :competitor
  has_and_belongs_to_many :grands
  validates :start_date, presence: true
  validates :sport, presence: true
  validates :country, presence: true
end
