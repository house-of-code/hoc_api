Trestle.resource(:devices, scope: ActsAsHocPushable) do
  remove_action :new
  menu do
    group :Admin, priority: 1 do
      item :devices, icon: 'fa fa-mobile', badge: { text: ActsAsHocPushable::Device.all.count, class: "label-primary label-pill" }, priority: 2
    end
  end

  table do
    column :parent do |device|
      device.parent.email
    end
    column :platform
    column :platform_version
    column :push_environment
    actions
  end

  form do |acts_as_hoc_pushable_device|
    select :parent_id, User.all.collect{ |u| [ u.email, u.id ] }, label: 'User'
    hidden_field :parent_type, value:'User'
    text_field :token
    row do
      col(xs: 4) { select :platform, ["ios", "android"] }
      col(xs: 4) { text_field :platform_version }
      col(xs: 4) { select :push_environment, ["sandbox", "production"] }
    end
  end
end
