class UserFollower < ApplicationRecord
  self.table_name = "users_followers"

  belongs_to :user
  belongs_to :follower, foreign_key: :follower_id, class_name: "User"
end
