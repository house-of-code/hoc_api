Trestle.resource(:users) do

  menu do
    group :Admin, priority: 1 do
      item :users, icon: 'fa fa-users', badge: { text: User.all.count, class: "label-primary label-pill" }, priority: 1
    end
  end

  table do
    column :name
    column :email
    column :ios_devices do |u| u.ios_devices.count end
    column :android_devices do |u| u.android_devices.count end
    actions
  end

  scope :all, default: true

  form do |user|
    tab :user do
      text_field :name
      email_field :email
      row do
        col(xs: 6) { password_field :password }
        col(xs: 6) { password_field :password_confirmation }
      end
    end
    tab :devices, badge: user.devices.count do
      table user.devices do
        column :platform
        column :platform_version
        column :push_environment
        actions
      end
    end
    tab :received_notifications, badge: user.received_notifications.count do
      table user.received_notifications do
        column :sender do |note|
          if note.sender_type.eql?('User')
            note.sender.name
          else
            note.sender_type
          end
        end
        column :notifiable do |note|
          note.notifiable.to_s
        end
        column :title
        column :action
        column :created_at, align: :center
        column :seen do |note|
          if note.seen_at.nil?
            ""
          else
            icon("fa fa-check")
          end
        end
      end
    end
    tab :sent_notifications, badge: user.sent_notifications.count do
      table user.sent_notifications do
        column :recipient do |note|
          if note.recipient_type.eql?('User')
            note.recipient.name
          else
            note.sender_type
          end
        end
        column :notifiable do |note|
          note.notifiable.to_s
        end
        column :title
        column :action
        column :created_at, align: :center
        column :seen do |note|
          if note.seen_at.nil?
            ""
          else
            icon("fa fa-check")
          end
        end
      end
    end
  end
end
