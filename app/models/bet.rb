# == Schema Information
#
# Table name: bets
#
#  id          :integer          not null, primary key
#  sport       :string
#  start_date  :datetime
#  country     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  pay_per_tie :float
#  tournament  :string
#  finish      :boolean
#  result      :integer
#  end_date    :datetime
#

class Bet < ApplicationRecord
  has_many :competitors_per_bet, class_name: 'Part',
                                 foreign_key: 'bet_id',
                                 dependent: :destroy
  has_many :competitors, through: :competitors_per_bet, source: :competitor
  has_and_belongs_to_many :grands
  validates :start_date, presence: true
  validates :sport, presence: true
  validates :country, presence: true,
                      format: { with: /\A[a-z '-]+\z/i,
                                message: 'País debe estar compuesto solo
                                         por letras, espacios, guiones y
                                         apostrofes.' }

  scope :active_bets, (-> { where(finish: false) })
end
