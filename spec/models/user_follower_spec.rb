require 'rails_helper'

RSpec.describe UserFollower, type: :model do
  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:follower).class_name('User') }
  end
end
