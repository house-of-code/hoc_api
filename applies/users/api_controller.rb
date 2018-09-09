info "adds authentication method to api controller"
insert_into_file 'app/controllers/api/v1/api_controller.rb', after: '# methods' do <<-'API_CONTROLLER_METHODS'

  def authenticate_request
    @current_user = User.authenticate_with_http_headers(request.headers)
    render_not_authorized unless @current_user
  end

  API_CONTROLLER_METHODS
end

insert_into_file 'app/controllers/api/v1/api_controller.rb', after: '# before_actions' do <<-'API_CONTROLLER_BEFORE_ACTIONS'

  before_action :authenticate_request

  API_CONTROLLER_BEFORE_ACTIONS
end

insert_into_file 'app/controllers/api/v1/api_controller.rb', after: '# attrs' do <<-'API_CONTROLLER_ATTRS'

  attr_reader :current_user

  API_CONTROLLER_ATTRS
end

# Permit user fields in controller
info "updates profile controller"
gsub_file "app/controllers/api/v1/profiles_controller.rb",
  "params.require(:profile).permit!",
  "params.require(:profile).permit(:email, :password, :password_confirmation, #{user_field_names.join(",")})"
