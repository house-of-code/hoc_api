require 'swagger_helper'
describe 'House of Code API' do
  path '/api/v1/authentication' do
    post 'Login an user' do
      tags 'Authentication'
      description "Login an user with an email and a password"
      produces 'application/json'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: {
          '$ref' => '#/definitions/session_input'
      }

      response '201', 'User authenticated' do
        schema '$ref' => '#/definitions/session'
        run_test!
      end
      response '401', 'Not authorized' do
        schema '$ref' => '#/definitions/error'
        run_test!
      end
    end

    delete 'Logout an user' do
      tags 'Authentication'
      description "Logout an user"
      produces 'application/json'
      consumes 'application/json'
      parameter name: :Authorization, :in => :header, required: true, :type => :string
      response '200', 'User logged out' do
        run_test!
      end
      response '401', 'Not authorized' do
        schema '$ref' => '#/definitions/error'
        run_test!
      end
    end
  end
end
