class User < ApplicationRecord
  has_secure_password

  has_many :user_followers
  has_many :followers, through: :user_followers, class_name: "User"

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, unless: -> { password.nil? }
end
