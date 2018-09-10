# install pundit and include pundit in application controller
return unless enable_pundit?
info "Installs pundit."
generate 'pundit:install'
