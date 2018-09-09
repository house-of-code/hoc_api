info "adds pundit include api controller"
insert_into_file 'app/controllers/api/v1/api_controller.rb', after: '# includes' do <<-'API_CONTROLLER_INCLUDES'

  include Pundit

  API_CONTROLLER_INCLUDES
end
