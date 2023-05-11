require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:user_followers) }
    it { should have_many(:followers) }
    it { should have_many(:sleep_routines) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should have_secure_password }
    it { should validate_length_of(:password).is_at_least(6) }
  end
end
