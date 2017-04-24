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
  has_and_belongs_to_many :accepted_bets, class_name: 'UserBet', join_table: :user_user_bets
  has_many :user_bets, dependent: :destroy
  validates :username, presence: true,
                       uniqueness: true,
                       length: { minimum: 6, maximum: 50 }
  validates :name, presence: true,
                   format: { with: /\A[a-z '-]+\z/i,
                             message: 'Nombre debe estar compuesto solo
                                       por letras, espacios, guiones y
                                      apostrofes.' },
                   length: { minimum: 2, maximum: 50 }
  validates :lastname, presence: true,
                       format: { with: /\A[a-z '-]+\z/i,
                                 message: 'Apellido debe estar compuesto solo
                                           por letras, espacios, guiones y
                                          apostrofes.' },
                       length: { minimum: 2, maximum: 50 }
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
