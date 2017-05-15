# == Schema Information
#
# Table name: pending_relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class PendingRelationshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
