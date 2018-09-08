class Api::V1::NotificationsController < Api::V1::ApiController

  def index
    @notifications = @current_user.received_notifications
    render_result(@notifications.as_api_response(:basic))
  end

  def show
    @notification = @current_user.received_notifications.find(params[:id])
    render_result(@notification.as_api_response(:basic))
  end


  def mark_as_seen
    if params[:id]
      @notification = @current_user.received_notifications.find(params[:id])
      @notification.mark_as_seen
    else
      @notifications= @current_user.received_notifications
      @notifications.update_all(seen_at: Time.zone.now)
    end
    render_nothing
  end
end
