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

# Slim for html
gem "slim-rails"

# Resource authentication
gem 'pundit' if enable_pundit?

# Cors
gem 'rack-cors' if enable_cors?

# Trestle admin interface
gem 'trestle' if enable_admin?

# Pagination
gem 'kaminari'

if enable_user_avatar?
  gem 'acts_as_hoc_avatarable'
  gem 'aws-sdk-s3', require: false
end
gem_group :development, :test do
  # Testing
  gem "rspec-rails"
  # Annotate models
  gem "annotate", ">= 2.5.0"
  # Awesomeness
  gem "awesome_print"
  # Analysis
  gem "rubocop", ">= 0.58.0", require: false
  # More readable errors
  gem "better_errors"
  # Find security holes
  gem "brakeman", require: false
  # The master utility for HoC API
  gem 'hoc_utils'
end
