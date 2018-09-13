# Template for creating a Rails API app

This template can be used for creating a new app with an api defined for authentication, profile and notifications

# Minimum requirements
* ***Rails 5.2*** (because of ActiveStorage)
* ***PostgreSQL must be installed***

## Gem packages included

### App Features
* [acts_as_api]
  Makes creating XML/JSON responses in Rails 3, 4 and 5 easy and fun.
* [rswag]
  rspec-rails is a testing framework for Rails 3.x, 4.x and 5.x.
* [acts_as_hoc_user]
  User model with authentication methods (JWT)
* [acts_as_hoc_pushable]
  Adds devices to model and possiblity to send push messages (FCM)
* [acts_as_hoc_avatarable]
  Add avatar to model with ActiveStorage.
* [aws-sdk-s3]
  The official AWS S3 SDK for Ruby.
* [hoc_notifications]
  Notification system for ActiveRecord models
* [simple_command]
  Service Objects for rails
* rack-cors (can be omitted)
  Provides support for Cross-Origin Resource Sharing (CORS) for Rack compatible web applications.
* [pundit] (can be omitted)
  Pundit provides a set of helpers which guide you in leveraging regular Ruby classes and object oriented design patterns to build a simple, robust and scaleable authorization system.
* [slim-rails]
  slim-rails provides Slim generators for Rails 3+. It was based on haml-rails and it does basically the same:
* [trestle]
  A modern, responsive admin framework for Ruby on Rails

### Development tools
* [hoc_utils] Utilities for HoC API
* [rspec-rails]
  rspec-rails is a testing framework for Rails 3.x, 4.x and 5.x.
* [annotate]
  Annotates models with summary of current schema
* [awesome_print]
  The awesome alternative to puts
* [rubocop]
   A Ruby static code analyzer and code formatter.
* [better_errors]
  Better Errors replaces the standard Rails error page with a much better and more useful error page.
* [brakeman]
  Brakeman is a static analysis tool which checks Ruby on Rails applications for security vulnerabilities.

## Usage

1. Clone this repository somewhere on your machine.
2. Create an api with the name _app_name_ with this command:



        $ rails new app_name --api -d postgresql -q -m path/to/repo/hoc_api_template.rb    



This will create a new rails app with postgresql as database using the hoc_api_template.rb.
### Explain please...
* `rails new app_name` will create an app with the name app_name
* `--api` normally means that it is gonna be an api only app. But not in this case; It just makes sure on the most important things are added to the project
* The `-q` option hide the very verbose output from rails generation.
* The `-m path/to/repo/hoc_api_template.rb` option tells to apply the this template.

### Template applying.

Doing the applying of the template you will be prompted for some answers. You can accept the default answer(indicated by `[]` - eg. `[y]`) by pressing *enter*.

### What now?
After the template is applied you can change directory into the newly created directory and start rails by typing

    $ rails server

### Configuration
Look into the `config` directory and check files if they need to be tweeked... Especially files in `initilizers` are worth looking at.

[rails-cors]:https://github.com/cyu/rack-cors
[rbenv]:https://github.com/sstephenson/rbenv
[Homebrew]:http://brew.sh
[hoc_api]:http:https://bitbucket.org/houseofcode/rails-template/src/master/
[acts_as_api]:http://www.christianbaeuerlein.com/acts_as_api/
[rspec-rails]:https://github.com/rspec/rspec-rails
[rswag]:https://github.com/domaindrivendev/rswag
[acts_as_hoc_user]:https://github.com/house-of-code/acts_as_hoc_user
[acts_as_hoc_pushable]:https://github.com/house-of-code/acts_as_hoc_pushable
[hoc_notifications]:https://github.com/house-of-code/hoc_notifications
[simple_command]:https://github.com/nebulab/simple_command
[pundit]:https://github.com/varvet/pundit
[annotate]:https://github.com/ctran/annotate_models
[awesome_print]:https://github.com/awesome-print/awesome_print
[rubocop]:https://github.com/rubocop-hq/rubocop
[better_errors]:https://github.com/BetterErrors/better_errors
[brakeman]:https://github.com/presidentbeef/brakeman
[trestle]:https://github.com/TrestleAdmin/trestle
[mini_magick]:https://github.com/minimagick/minimagick
[aws-sdk-s3]:https://github.com/aws/aws-sdk-ruby
[acts_as_hoc_avatarable]:https://github.com/house-of-code/acts_as_hoc_avatarable
[slim-rails]:https://github.com/slim-template/slim-rails
[hoc_utils]:https://github.com/house-of-code/hoc_utils
