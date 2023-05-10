require 'swagger_helper'

RSpec.describe 'authentication', type: :request do

  path '/auth/login' do
    post('login authentication') do
      consumes 'application/json'
      produces 'application/json'
      parameter name: :authentication, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response '200', 'Ok' do
        let(:user) { FactoryBot.create(:user, email: 'test@test.com', password: 'password') }
        let(:authentication) { { email: user.email, password: user.password } }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:authentication) { { email: nil, password: nil } }
        run_test!
      end
    end
  end
end
