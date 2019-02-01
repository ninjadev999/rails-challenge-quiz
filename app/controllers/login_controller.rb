class LoginController < ApplicationController
  skip_before_action :set_current_user, :authenticate_request

  def login
    # TODO authenticate the user and set
    # it as the current user
    #
    # If the user is present responde with
    # the user's access_token and a status
    # code of 200
    #
    # Else respond with a message and an
    # unauthorized status code
    if login_param[:email].present? && login_param[:password].present?
      @current_user = User.authenticate(login_param[:email], login_param[:password])
      return render json: {access_token: @current_user.access_token('user')}, status: :ok if @current_user
    end

    render json: { message: 'Not Authorized' }, status: 401
  end

  private

  def login_param
    params.permit(:email, :password)
  end
end
