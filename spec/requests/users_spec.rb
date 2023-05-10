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
        let(:id) { FactoryBot.create(:user).id }
        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }
        let(:user) { { name: 'Thanos' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.dig('data', 'attributes', 'name')).to eq 'Thanos'
        end
      end

      response '422', 'Unprocessable Entity' do
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
        let(:id) { FactoryBot.create(:user).id }
        let(:current_user) { FactoryBot.create(:user) }
        let('Authorization') { generate_auth_token(current_user) }
        run_test!
      end
    end
  end
end
