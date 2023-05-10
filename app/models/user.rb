class User < ApplicationRecord
  has_many :user_followers
  has_many :followers, through: :user_followers, class_name: "User"

  validates :name, presence: true
end
