insert_into_file 'spec/swagger_helper.rb', after: '# add your definitions here.' do <<-'DEFINITION'

        notification: {
          description: 'This model contains information about a notification',
          type: 'object',
          properties: {
            id: { type: 'integer' },
            title: { type: 'string' },
            message: { type: 'string' },
            action: { type: 'string' },
            sender_id: { type: 'integer' },
            sender_type: { type: 'string' },
            notifiable_id: { type: 'integer' },
            notifiable_type: { type: 'string' },
            data: { type: 'string', description: 'json with extra data' },
          },
        },
        notifications: {
          description: 'An array of notifications',
            type: 'array',
            items: { "$ref": "#/definitions/notification" },
        },
        
  DEFINITION
end
