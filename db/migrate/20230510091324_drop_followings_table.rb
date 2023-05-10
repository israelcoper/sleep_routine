class DropFollowingsTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :followings, if_exists: true
  end
end
