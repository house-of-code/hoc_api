class Api::V1::ProfilesController < Api::V1::ApiController
  skip_before_action :authenticate_request, only: [:create]
  def create
    if User.where(email: params[:email]).count > 0
      render_error("User exists", :conflict) and return
    end
    @current_user = User.new(user_params)
    if @current_user.save
      @authentication_token = @current_user.authentication_token
      render_result({authentication_token: @authentication_token, user: @current_user.as_api_response(:basic) })
    else
      render_error(@current_user.errors.full_messages.first)
    end
  end

  # GET /api/v1/users/
  def show
    render_result(@current_user.as_api_response(:basic))
  end

  # PATCH /api/v1/users/
  def update
    if @current_user.update(user_params)
      render_result(@current_user.as_api_response(:basic))
    else
      render_error(@current_user.errors.full_messages.first)
    end
  end

  # DELETE /api/v1/users
  def destroy
    if @current_user.destroy
      render_nothing(:deleted)
    else
      render_error(@current_user.errors.full_messages.first)
    end
  end

  # POST /api/v1/users/add_device
  def add_device
    if @current_user.add_device(device_params)
      render_nothing
    else
      render_error(@current_user.errors.full_messages.first)
    end
  end

  private

  def user_params
    params.require(:user).permit!
  end

  def device_params
    params.require(:device).permit(:token, :platform, :platform_version, :push_environment)
  end
end
