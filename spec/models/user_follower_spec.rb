require 'rails_helper'

RSpec.describe UserFollower, type: :model do
  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:follower).class_name('User') }
  end

  describe 'validation' do
    describe 'follower id uniqueness' do
      let(:user) { FactoryBot.create(:user) }
      let(:follower) { FactoryBot.create(:user) }

      let!(:user_follower) { user.user_followers.create(follower: follower) }

      it 'creates follower' do
        expect(user_follower.user).to eq user

        new_user = FactoryBot.create(:user)
        new_follower = new_user.user_followers.new(follower: follower)

        expect(new_follower.valid?).to eq true
      end

      it 'returns error' do
        new_follower = user.user_followers.new(follower: follower)
        new_follower.valid?
        expect(new_follower.errors.full_messages.to_sentence).to eq 'Follower has already been taken'
      end
    end
  end
end
