# == Schema Information
#
# Table name: grands
#
#  id         :integer          not null, primary key
#  amount     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  end_date   :datetime
#  user_id    :integer
#

class Grand < ApplicationRecord
  has_many :bets_per_grand, class_name: 'MakeUp',
                            foreign_key: 'grand_id',
                            dependent: :destroy
  has_many :bets, through: :bets_per_grand, source: :bet
  belongs_to :user
  validates :amount, presence: true,
            numericality: { only_integer: true, greater_than: 0 }
end
