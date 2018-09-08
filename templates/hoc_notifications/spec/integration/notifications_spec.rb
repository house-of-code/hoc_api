require 'swagger_helper'
describe 'House of Code API' do
  path '/api/v1/notifications' do

    get 'Get notifications' do
      tags 'Notifications'
      description "Gets notifications"
      produces 'application/json'
      consumes 'application/json'
      parameter name: :Authorization, :in => :header, required: true, :type => :string
      response '200', 'Notifications' do
        schema '$ref' => '#/definitions/notifications'
        run_test!
      end
      response '401', 'Not authorized' do
        schema '$ref' => '#/definitions/error'
        run_test!
      end
    end
  end
  path '/api/v1/notifications/mark_as_seen' do
    put 'Mark all notifications as seen' do
      tags 'Notifications'
      description "Mark all notifications as seen"
      produces 'application/json'
      consumes 'application/json'
      parameter name: :Authorization, :in => :header, required: true, :type => :string
      response '200', 'Notifications' do
        examples 'application/json' => { }
        run_test!
      end
      response '401', 'Not authorized' do
        schema '$ref' => '#/definitions/error'
        run_test!
      end
    end
  end

  path '/api/v1/notifications/{id}' do
    get 'Get notification' do
      tags 'Notifications'
      description "Gets a notification"
      produces 'application/json'
      consumes 'application/json'
      parameter name: :id, :in => :path, :type => :integer
      parameter name: :Authorization, :in => :header, required: true, :type => :string
      response '200', 'Notifications' do
        schema '$ref' => '#/definitions/notification'
        run_test!
      end
      response '401', 'Not authorized' do
        schema '$ref' => '#/definitions/error'
        run_test!
      end
    end
  end

  path '/api/v1/notifications/{id}/mark_as_seen' do
    put 'Mark a notification as seen' do
      tags 'Notifications'
      description "Mark a notification as seen"
      produces 'application/json'
      consumes 'application/json'
      parameter name: :id, :in => :path, :type => :integer
      parameter name: :Authorization, :in => :header, required: true, :type => :string
      response '200', 'Notifications' do
        examples 'application/json' => { }
        run_test!
      end
      response '401', 'Not authorized' do
        schema '$ref' => '#/definitions/error'
        run_test!
      end
    end
  end
end
