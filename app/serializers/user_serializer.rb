class UserSerializer
  include JSONAPI::Serializer

  attribute :name
  attribute :email
  attribute :created_at
  attribute :updated_at
end
