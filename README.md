# Template for creating a Rails API app

This template can be used for creating a new app with an api defined for authentication, profile and notifications

## Gems included
* acts_as_api
* will_paginate
* rspec-rails (~> 3.5)
* rswag
* acts_as_hoc_user
* acts_as_hoc_pushable
* hoc_notifications
* simple_command

## Usage

To create an api with the name _app_name_ call this command:

    $ rails new app_name --api -d postgresql -m hoc_api_template.rb

This will create a new api-only rails app with postgresql as database using the hoc_api_template.rb
