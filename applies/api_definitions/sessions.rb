insert_into_file 'spec/swagger_helper.rb', after: '# add your definitions here.' do <<-'DEFINITION'
  
        session_input: {
          description: 'This model contains information for logging in an user',
          type: 'object',
          properties: {
            password: { type: 'string', format: 'password' },
            email: { type: 'string', format: 'email' },
          },
          required: ['password', 'email']
        },
        session: {
          description: 'This model contains information for logging in an user',
          type: 'object',
          properties: {
            authentication_token: { type: 'string' },
            profile: { "$ref": "#/definitions/profile" },
          },
        },
  DEFINITION
end
