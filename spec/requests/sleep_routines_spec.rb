require 'swagger_helper'

RSpec.describe 'sleep_routines', type: :request do

  path '/users/{user_id}/sleep_routines' do
    parameter name: :user_id, in: :path, type: :string, description: 'user_id'
    parameter name: 'Authorization', in: :header, type: :string

    # SleepRoutinesController#index
    get 'List a user sleep routines' do
      produces 'application/json'

      response '200', 'Ok' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            user_id: { type: :integer },
            start_at: { type: :string },
            end_at: { type: :string },
            duration_in_seconds: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string }
          }

        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }
        let(:user_id) { current_user.id }
        let!(:sleep_routine_0) { FactoryBot.create(:sleep_routine, user: current_user, start_at: 3.days.ago, end_at: 3.days.ago + 5.hours) }
        let!(:sleep_routine_1) { FactoryBot.create(:sleep_routine, user: current_user, start_at: 2.days.ago, end_at: 2.days.ago + 4.hours) }
        let!(:sleep_routine_2) { FactoryBot.create(:sleep_routine, user: current_user, start_at: 1.day.ago, end_at: 1.days.ago + 6.hours) }
        let!(:sleep_routine_3) { FactoryBot.create(:sleep_routine, user: current_user, start_at: DateTime.now, end_at: DateTime.now + 4.hours) }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:user_id) { FactoryBot.create(:user).id }
        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }

        run_test!
      end
    end

    # SleepRoutinesController#create
    post('Create a user sleep routine') do
      produces 'application/json'

      response(201, 'Created') do
        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }
        let(:user_id) { current_user.id }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:user_id) { FactoryBot.create(:user).id }
        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }

        run_test!
      end
    end
  end

  path '/users/{user_id}/sleep_routines/{id}' do
    parameter name: :user_id, in: :path, type: :string, description: 'user_id'
    parameter name: :id, in: :path, type: :string, description: 'Sleep routine id'
    parameter name: 'Authorization', in: :header, type: :string

    # SleepRoutinesController#update
    put('Update a user sleep routine') do
      produces 'application/json'

      response(200, 'Ok') do
        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }
        let(:user_id) { current_user.id }
        let(:id) { FactoryBot.create(:sleep_routine, user: current_user, start_at: DateTime.now, end_at: nil).id }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:user) { FactoryBot.create(:user) }
        let(:user_id) { user.id }
        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }
        let(:id) { FactoryBot.create(:sleep_routine, user: user, start_at: DateTime.now, end_at: nil).id }

        run_test!
      end
    end
  end
end
