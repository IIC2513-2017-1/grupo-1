# == Schema Information
#
# Table name: parts
#
#  id            :integer          not null, primary key
#  competitor_id :integer
#  bet_id        :integer
#  multiplicator :float
#  local         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class PartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
