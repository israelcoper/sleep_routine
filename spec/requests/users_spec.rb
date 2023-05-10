require 'swagger_helper'

RSpec.describe 'users', type: :request do
  path '/users' do
    # UsersController#index
    get 'List users' do
      produces 'application/json'

      response '200', 'Ok' do
        schema type: :array,
          items: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string }
          }

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
          name: { type: :string }
        },
        required: [ 'name' ]
      }

      response '201', 'Created' do
        let(:user) { { name: 'John' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq 'John'
        end
      end

      response '422', 'Unprocessable Entity' do
        let(:user) { { name: nil } }
        run_test!
      end
    end
  end

  path '/users/{id}' do
    parameter name: :id, in: :path, type: :string

    # UsersController#show
    get 'Retrieve a user' do
      produces 'application/json'
      response '200', 'Ok' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string }
          }

        let(:id) { FactoryBot.create(:user).id }
        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { 'invalid' }
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
          name: { type: :string }
        },
        required: [ 'name' ]
      }

      response '200', 'Ok' do
        let(:id) { FactoryBot.create(:user).id }
        let(:user) { { name: 'Thanos' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq 'Thanos'
        end
      end

      response '422', 'Unprocessable Entity' do
        let(:id) { FactoryBot.create(:user).id }
        let(:user) { { name: nil } }
        run_test!
      end
    end

    # UsersController#destroy
    delete 'Delete a user' do
      response '204', 'No Content' do
        let(:id) { FactoryBot.create(:user).id }
        run_test!
      end
    end
  end
end
