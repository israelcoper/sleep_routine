require 'rails_helper'

RSpec.describe SleepRoutine, type: :model do
  describe 'association' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:start_at) }
    it { should validate_presence_of(:end_at).on(:update) }

    describe 'duration in seconds numericality' do
      let(:user) { FactoryBot.create(:user) }
      let(:sleep_routine) do
        FactoryBot.build(
          :sleep_routine,
          user: user,
          start_at: DateTime.now,
          end_at: DateTime.now + 5.hours
        )
      end

      it 'creates sleep routine' do
        expect(sleep_routine.valid?).to eq true
      end
    end
  end
end
