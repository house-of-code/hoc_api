require 'rails/application_controller'

class HomeController < Rails::ApplicationController # :nodoc:
  layout false
  def index
    render file: Rails.root.join('public', 'index.html.erb')
  end
end
