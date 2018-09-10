Trestle.resource(:hoc_notifications, scope: HocNotifications) do
  remove_action :new
  menu do
    group :Admin, priority: 1 do
      item :hoc_notifications, icon: 'fa fa-envelope-open', badge: { text: HocNotifications::HocNotification.all.count, class: "label-primary label-pill" },label: "Notifications", priority: 3

    end
  end

  table(autolink: false) do
    column :sender do |note|
      if note.sender_type.eql?('User')
        note.sender.name
      else
        note.sender_type
      end

    end
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
    actions
  end
end
