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
#  checked    :boolean
#

require 'test_helper'

class GrandTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
