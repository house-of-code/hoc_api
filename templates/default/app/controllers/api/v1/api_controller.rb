class Api::V1::ApiController < ApplicationController
  # includes
  include ActsAsApi::Rendering

  # before_actions

  # rescues
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  # attrs


  # methods
  def render_result(json, status = :ok)
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
end
