class SleepRoutine < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true, on: :update
  validates :duration_in_seconds, numericality: { only_integer: true }, if: -> { start_at.present? && end_at.present? }

  before_validation :set_duration_in_seconds, unless: -> { end_at.nil? }

  private

  def set_duration_in_seconds
    self.duration_in_seconds = TimeDifference.between(start_at, end_at).in_seconds.round.to_i
  end
end
