require 'swagger_helper'

RSpec.describe 'sleep_routines', type: :request do

  path '/users/{user_id}/sleep_routines' do
    parameter name: :user_id, in: :path, type: :string, description: 'user_id'
    parameter name: 'Authorization', in: :header, type: :string

    post('Create a user sleep routine') do
      produces 'application/json'

      response(201, 'Created') do
        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }
        let(:user_id) { current_user.id }

        run_test!
      end
    end
  end

  path '/users/{user_id}/sleep_routines/{id}' do
    parameter name: :user_id, in: :path, type: :string, description: 'user_id'
    parameter name: :id, in: :path, type: :string, description: 'Sleep routine id'
    parameter name: 'Authorization', in: :header, type: :string

    put('Update a user sleep routine') do
      produces 'application/json'

      response(200, 'Ok') do
        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }
        let(:user_id) { current_user.id }
        let(:id) { FactoryBot.create(:sleep_routine, user: current_user, start_at: DateTime.now, end_at: nil).id }

        run_test!
      end
    end
  end
end
