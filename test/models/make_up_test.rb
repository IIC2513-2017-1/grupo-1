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

require 'test_helper'

class MakeUpTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
