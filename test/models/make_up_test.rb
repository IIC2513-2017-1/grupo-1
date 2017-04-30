# == Schema Information
#
# Table name: make_ups
#
#  id         :integer          not null, primary key
#  bet_id     :integer
#  grand_id   :integer
#  selection  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class MakeUpTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
