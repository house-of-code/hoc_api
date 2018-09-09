# install pundit and include pundit in application controller
if enable_pundit?
  info "Installs pundit"
  generate 'pundit:install'
  apply("applies/pundit/api_controller.rb")
end
