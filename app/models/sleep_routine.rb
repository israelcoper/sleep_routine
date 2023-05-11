class SleepRoutine < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true, on: :update
  validates :duration_in_seconds, numericality: { only_integer: true }, if: -> { start_at.present? && end_at.present? }

  before_validation :set_duration_in_seconds, unless: -> { end_at.nil? }

  scope :records_from_previous_week, -> (followers_ids, page_number = nil, page_size = nil) do
    self
      .where.not(duration_in_seconds: nil)
      .where(user_id: followers_ids)
      .where("start_at BETWEEN ? AND ?", 7.days.ago, Time.now)
      .order("duration_in_seconds DESC")
      .page(page_number)
      .per(page_size)
  end

  private

  def set_duration_in_seconds
    self.duration_in_seconds = TimeDifference.between(start_at, end_at).in_seconds.round.to_i
  end
end
