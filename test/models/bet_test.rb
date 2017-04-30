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
#

require 'test_helper'

class BetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
