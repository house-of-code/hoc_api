# Easy json generation
gem 'acts_as_api'
# Makes it possible to paginate results
#gem 'will_paginate'
# Testing
gem 'rspec'
# API documentation and testing
gem 'rswag'
# Easy user authentication
gem 'acts_as_hoc_user'
# Easy push notifications through firebase
gem 'acts_as_hoc_pushable'
# Makes models notifiable, receivable and sendable
gem 'hoc_notifications'
# Service objects for rails
gem 'simple_command'


# Resource authentication
gem 'pundit' if enable_pundit?

# Cors
gem 'rack-cors' if enable_cors?

# Trestle admin interface
gem 'trestle' if enable_admin?

if enable_user_avatar?
  gem 'mini_magick'
  gem 'aws-sdk-s3', require: false
end
gem_group :development, :test do
  # Testing
  gem "rspec-rails"
  gem "annotate", ">= 2.5.0"
  gem "awesome_print"
  gem "rubocop", ">= 0.58.0", require: false
  gem "better_errors"
  gem "brakeman", require: false
end
