class SleepRoutineSerializer
  include JSONAPI::Serializer

  attribute :start_at
  attribute :end_at
  attribute :duration_in_seconds
  attribute :created_at
  attribute :updated_at
end
