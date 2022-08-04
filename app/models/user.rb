# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  first_name      :string           not null
#  last_name       :string
#  password_digest :text             not null
#  role            :string
#  token           :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_token  (token) UNIQUE
#
class User < ApplicationRecord
  include Filterable
  # before_save { self.email = email.downcase }
  has_secure_password
  has_secure_token
  has_many :bookings, dependent: :destroy

  scope :ascending, -> { order(email: :asc) }

  scope :lf_user, ->(str) { where('first_name LIKE :q OR last_name LIKE :q OR email LIKE :q', q: "%#{str.downcase}%") } # rubocop:disable Layout/LineLength

  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :token, uniqueness: true
  validates :password, presence: true, length: { minimum: 3 }, on: :create
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX, message: 'Email invalid' }

  def admin?
    role == 'admin'
  end
end
