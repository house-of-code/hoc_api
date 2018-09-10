class Api::V1::AuthenticationsController < Api::V1::ApiController
  skip_before_action :authenticate_request, except: [:logout]

  def create
    @authentication_token =  User.authenticate_with_credentials(credentials_params[:email], credentials_params[:password])
    @current_user = User.authenticate_with_authentication_token(@authentication_token)
    render_result({authentication_token: @authentication_token, user: @current_user.as_api_response(:basic) })
  end

  def destroy
    render_nothing
  end

  private

  def credentials_params
    params.require(:credentials).permit(:email, :password)
  end
end
