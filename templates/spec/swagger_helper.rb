require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.to_s + '/swagger'
  config.swagger_docs = {
    'v1/swagger.json' => {
      swagger: '2.0',
      info: {
        title: 'House of Code Api V1',
        version: 'v1',
        description: 'API documentation',
        contact: {
          name: 'House of Code ApS',
          email: 'info@houseofcode.io',
          url: 'https://houseofcode.io'
        }
      },

      #host: 'url_to_where',
      #host: 'localhost:3000',
      paths: {},
      definitions: {
        # add your definitions here.
        error: {
          description: 'Error message',
          type: 'object',
          properties: {
            status: { type: 'integer' },
            error: { type: 'string' }
          }
        },
      }
    }
  }
end
