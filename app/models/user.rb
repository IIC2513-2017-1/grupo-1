# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  username   :string
#  role       :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  validates :name, presence: true
end
