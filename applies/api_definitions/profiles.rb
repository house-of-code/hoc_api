profile_defs = ""
@splitted_fields.each do |field|
  profile_defs << "#{field[:name]}: { type: '#{field[:type]}' },"
end

insert_into_file 'spec/swagger_helper.rb', after: '# add your definitions here.' do
  <<-DEFINITION

        profile_input: {
          description: 'This model contains information for creating an user',
          type: 'object',
          properties: {
            email: { type: 'string', format: 'email' },
            password: { type: 'string', format: 'password' },
            password_confirmation: { type: 'string', format: 'password' },
            #{profile_defs}
          },
          required: ['email']
        },
        profile: {
          description: 'This model contains information about an user',
          type: 'object',
          properties: {
            id: { type: 'integer' },
            email: { type: 'string', format: 'email' },
            #{profile_defs}
          }
        },
        device: {
          description: 'This model contains information for adding a device to a profile',
          type: 'object',
          properties: {
            token: { type: 'string' },
            platform: { type: 'string', description: 'ios or android' },
            platform_version: { type: 'string', description: 'eg. 9.3' },
            push_environment: { type: 'string', description: 'production or debug' },
          },
          required: ['token', 'platform', 'platform_version', 'push_environment']
        },
        
  DEFINITION
end
