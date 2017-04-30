# == Schema Information
#
# Table name: competitors
#
#  id         :integer          not null, primary key
#  name       :string
#  country    :string
#  sport      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Competitor < ApplicationRecord
  has_and_belongs_to_many :bets
end
