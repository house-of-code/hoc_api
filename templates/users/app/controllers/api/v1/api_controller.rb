class Api::V1::ApiController < ApplicationController
  include ActsAsApi::Rendering
  before_action :authenticate_request
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  attr_reader :current_user

  def render_result(json, status)
    render json: json, status: status
  end

  def render_nothing(status = :ok)
    render json: {}, status: status
  end

  def render_not_authorized
    render_error("Not Authorized", 401)
  end

  def render_not_allowed
    render_error("Not allowed", :unauthorized)
  end

  def render_error(err, status = :unprocessable_entity)
    render json: { status: status, error: err }, status: status
  end

  def authenticate_request
    @current_user = User.authenticate_with_http_headers(request.headers)
    render_not_authorized unless @current_user
  end
end
