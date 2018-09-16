class Api::V1::NotificationsController < Api::V1::ApiController

  def index
    render_collection(@current_user.received_notifications.order(ordering_params(params)), :notifications)
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
