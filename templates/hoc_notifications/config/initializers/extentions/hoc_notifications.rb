require 'hoc_notifications/active_record/hoc_notification.rb'
module HocNotifications
  class HocNotification < ActiveRecord::Base
    acts_as_api

    api_accessible :basic do |template|
      template.add :id
      template.add :title
      template.add :message
      template.add :action
      template.add :sender_id
      template.add :sender_type
      template.add :notifiable_id
      template.add :notifiable_type
      template.add :data
      template.add :seen_at
      template.add :updated_at
      template.add :created_at
    end


  end
end
