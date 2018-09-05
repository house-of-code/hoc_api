module HocNotifications
  class HocNotification < ActiveRecord::Base
    acts_as_api

    api_accessible :basic do |template|
      template.add :id
      template.add :title
      template.add :message
      template.add :action
      template.add :sender
      template.add :sender_type
      template.add :notifiable
      template.add :notifiable_type
      template.add :data
      template.add :recipient
    end


  end
end
