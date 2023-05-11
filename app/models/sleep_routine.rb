class SleepRoutine < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true, on: :update
  validates :duration_in_seconds, numericality: { only_integer: true }, if: -> { start_at.present? && end_at.present? }
end
