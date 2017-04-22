# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  role            :string
#  email           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string
#  name            :string
#  lastname        :string
#  description     :string
#  money           :integer
#  birthday        :date
#

class User < ApplicationRecord
  validates :username, presence: true,
                       uniqueness: true,
                       length: { minimum: 6, maximum: 50 }
  validates :name, presence: true,
                   format: { with: /\A[A-Z]{1}[a-z]+\z/ },
                   length: { minimum: 3, maximum: 50 }
  validates :lastname, presence: true,
                       format: { with: /\A[A-Z]{1}[a-z]+\z/ },
                       length: { minimum: 3, maximum: 50 }
  validates :email, presence: true,
                    format:
                      { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i },
                    uniqueness: true,
                    length: { minimum: 6, maximum: 254 }
  has_secure_password

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end
end
