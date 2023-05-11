class CreateSleepRoutines < ActiveRecord::Migration[7.0]
  def change
    create_table :sleep_routines do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at
      t.integer :duration_in_seconds

      t.timestamps
    end
  end
end
