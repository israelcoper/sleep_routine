require 'swagger_helper'

RSpec.describe 'users', type: :request do
  path '/users' do
    # UsersController#index
    get 'List users' do
      produces 'application/json'
      parameter name: 'Authorization', in: :header, type: :string

      response '200', 'Ok' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            email: { type: :string }
          }

        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }
        run_test!
      end
    end

    # UsersController#create
    post 'Create a user' do
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[name email password]
      }

      response '201', 'Created' do
        let(:user) { FactoryBot.attributes_for(:user) }

        before do |example|
          submit_request(example.metadata)
        end

        xit 'returns a valid 201 response' do |example|
          assert_response_matches_metadata(example.metadata)
        end
      end

      response '422', 'Unprocessable Entity' do
        let(:user) { { name: nil, email: nil } }
        run_test!
      end
    end
  end

  path '/users/{id}' do
    parameter name: :id, in: :path, type: :string
    parameter name: 'Authorization', in: :header, type: :string

    # UsersController#show
    get 'Retrieve a user' do
      produces 'application/json'
      response '200', 'Ok' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            email: { type: :string }
          }

        let(:id) { FactoryBot.create(:user).id }
        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }
        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { 'invalid' }
        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }
        run_test!
      end
    end

    # UsersController#update
    put 'Update a user' do
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[name email password]
      }

      response '200', 'Ok' do
        let(:current_user) { FactoryBot.create(:user) }
        let(:id) { current_user.id }
        let('Authorization') { generate_auth_token(current_user) }
        let(:user) { { name: 'Thanos' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.dig('data', 'attributes', 'name')).to eq 'Thanos'
        end
      end

      response '422', 'Unprocessable Entity' do
        let(:current_user) { FactoryBot.create(:user) }
        let(:id) { current_user.id }
        let('Authorization') { generate_auth_token(current_user) }
        let(:user) { { name: nil } }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:id) { FactoryBot.create(:user).id }
        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }
        let(:user) { { name: nil } }
        run_test!
      end
    end

    # UsersController#destroy
    delete 'Delete a user' do
      response '204', 'No Content' do
        let(:current_user) { FactoryBot.create(:user) }
        let(:id) { current_user.id }
        let('Authorization') { generate_auth_token(current_user) }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:id) { FactoryBot.create(:user).id }
        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }
        run_test!
      end
    end
  end

  path '/users/{id}/follow' do
    parameter name: :id, in: :path, type: :string
    parameter name: 'Authorization', in: :header, type: :string

    # UsersController#follow
    post 'Follow a user' do
      produces 'application/json'

      response '201', 'Created' do
        let(:id) { FactoryBot.create(:user).id }
        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }
        run_test!
      end

      response '422', 'Unprocessable Entity' do
        let(:user) { FactoryBot.create(:user) }
        let(:id) { user.id }
        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }

        before do
          user.user_followers.create(follower: current_user)
        end

        run_test!
      end
    end
  end

  path '/users/{id}/unfollow' do
    parameter name: :id, in: :path, type: :string
    parameter name: 'Authorization', in: :header, type: :string

    # UsersController#unfollow
    post 'Unfollow a user' do
      produces 'application/json'

      response '200', 'Ok' do
        let(:user) { FactoryBot.create(:user) }
        let(:id) { user.id }
        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }

        before do
          user.user_followers.create(follower: current_user)
        end

        run_test!
      end

      response '404', 'Not found' do
        let(:id) { FactoryBot.create(:user).id }
        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }

        run_test!
      end
    end
  end

  path '/users/{id}/friends_sleeps' do
    parameter name: :id, in: :path, type: :string, description: 'User id'
    parameter name: 'Authorization', in: :header, type: :string

    # UsersController#friends_sleeps
    get 'List a user friends sleep records' do
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
        let(:id) { current_user.id }

        let(:follower_1) { FactoryBot.create(:user) }
        let(:follower_2) { FactoryBot.create(:user) }

        let!(:user_follower_1) { FactoryBot.create(:user_follower, user: current_user, follower: follower_1) }
        let!(:user_follower_2) { FactoryBot.create(:user_follower, user: current_user, follower: follower_2) }

        let!(:sleep_routine_0) { FactoryBot.create(:sleep_routine, user: follower_1, start_at: 3.days.ago, end_at: 3.days.ago + 5.hours) }
        let!(:sleep_routine_1) { FactoryBot.create(:sleep_routine, user: follower_2, start_at: 2.days.ago, end_at: 2.days.ago + 4.hours) }
        let!(:sleep_routine_2) { FactoryBot.create(:sleep_routine, user: follower_2, start_at: 1.day.ago, end_at: 1.days.ago + 6.hours) }
        let!(:sleep_routine_3) { FactoryBot.create(:sleep_routine, user: follower_1, start_at: DateTime.now, end_at: DateTime.now + 4.hours) }
        let!(:sleep_routine_4) { FactoryBot.create(:sleep_routine, user: follower_1, start_at: 8.days.ago, end_at: 8.days.ago + 4.hours) }

        run_test! do |example|
          data = JSON.parse response.body
          expect(data.dig('meta', 'total_count')).to eq 4
        end
      end

      response '401', 'Unauthorized' do
        let(:id) { FactoryBot.create(:user).id }
        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }
        run_test!
      end
    end
  end
end
