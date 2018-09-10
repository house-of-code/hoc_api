return unless enable_admin?
generate 'trestle:install'
if install_user?
  generate 'trestle:resource User'
  generate 'trestle:resource ActsAsHocPushable::Device'
  generate 'trestle:resource HocNotifications::HocNotification' if install_notifications?
  directory "templates/trestle/app", "app", force: true
end
comment_lines 'config/application.rb', /config.api_only = true/
environment 'config.api_only = false'

directory "templates/trestle/config", "config", force: true
environment "config.admin_password = '#{admin_password}'"
environment "config.admin_login = '#{admin_login}'"
