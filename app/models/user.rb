# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  username            :string
#  role                :string
#  email               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  password_digest     :string
#  name                :string
#  lastname            :string
#  description         :string
#  money               :integer
#  birthday            :date
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  email_confirmed     :boolean
#  confirm_token       :string
#

class User < ApplicationRecord
  before_create :confirmation_token
  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>' },
                             default_url: '/images/:style/missing.png'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name:  'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :pending_relationships, foreign_key: 'follower_id',
                                   dependent: :destroy
  has_many :assignations, class_name: 'Assignment',
                          foreign_key: 'user_id',
                          dependent: :destroy
  has_many :demands, through: :pending_relationships, source: :followed
  has_many :grands, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followeds, through: :passive_relationships, source: :follower
  has_many :bet_assignations, through: :assignations, source: :user_bet
  has_and_belongs_to_many :notifications, class_name: 'UserBet'
  has_and_belongs_to_many :accepted_bets, class_name: 'UserBet',
                                          join_table: :user_user_bets
  has_many :user_bets, dependent: :destroy
  validates :username, presence: true,
                       uniqueness: true,
                       length: { minimum: 6, maximum: 50 }
  validates :name, presence: true,
                   format: { with: /\A[a-z '-]+\z/i,
                             message: 'Nombre debe estar compuesto solo
                                       por letras, espacios, guiones, acentos y
                                      apostrofes.' },
                   length: { minimum: 2, maximum: 50 }
  validates :lastname, presence: true,
                       format: { with: /\A[a-z '-]+\z/i,
                                 message: 'Apellido debe estar compuesto solo
                                           por letras, espacios, guiones,
                                           acentos y apostrofes.' },
                       length: { minimum: 2, maximum: 50 }
  validates :email, presence: true,
                    confirmation: true,
                    format:
                      { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i },
                    uniqueness: true,
                    length: { minimum: 6, maximum: 254 }
  validates :role, presence: true, inclusion: %w[admin gambler]
  validates :money, numericality: { greater_than_or_equal_to: 0 }
  has_secure_password

  def admin?
    role == 'admin'
  end

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  def confirmation_token
    return unless confirm_token.blank?
    self.confirm_token = SecureRandom.urlsafe_base64.to_s
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(validate: false)
  end

  def generate_token_and_save
    loop do
      self.token = SecureRandom.hex(64)
      break if save
    end
  end
end
