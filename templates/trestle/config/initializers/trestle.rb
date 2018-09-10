
Trestle.configure do |config|
  config.site_title = "House of Code Admin"

  # config.menu do
  #   group "Badges & Labels", priority: 10 do
  #     item "Item with counter", "#", badge: { text: (1..100).to_a.sample, class: "label-primary label-pill" }, priority: 1
  #     item "Item with badge", "#", badge: { text: "NEW!", class: "label-success" }, icon: "fa fa-car", priority: 2
  #   end
  # end

  config.before_action do |_controller|
    authenticate_or_request_with_http_basic(Trestle.config.site_title) do |name, password|
      
      ActiveSupport::SecurityUtils.secure_compare(name, Rails.application.config.admin_login) &
        ActiveSupport::SecurityUtils.secure_compare(password, Rails.application.config.admin_password)
    end
  end

end
