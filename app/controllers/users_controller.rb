class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: :create

  def create
    # TODO create and save a new user
    #
    # Name, email, password and
    # password_confirmation are the fields
    # that will be sent in the request
    # body and available as params
    #
    # On success respond with the user
    # and a JWT token that the UI can
    # use to do further actions with a
    # status code of 200
    #
    # On fail respond with a message
    # with a message leveraging the
    # instance_error_message to send the error
    # full message or default message and
    # a status code of unprocessable entity status
    @user = User.new(user_params)

    if @user.save
      render json: {
                user: @user, 
                message: 'Account created successfully', 
                access_token: @user.access_token('user')
             }, 
             status: :created
    else
      render json: {message: @user.errors}, status: :unprocessable_entity
    end
  end

  def show
    # TODO respond with the current user
    render json: {user: @current_user}, status: :ok
  end

  def update
    # TODO update the current user's name
    # and/or email
    #
    # If it fails to mark as update, respond
    # with a message leveraging the
    # instance_error_message to send the error
    # full message or default message and
    # a status code of 422
    if @current_user.update(update_params)
      render json: {user: @current_user}
    else
      render json: {message: @current_user.errors}, status: :unprocessable_entity
    end
  end

  private

  def check_authentication_status
    render json: {access_token: @current_user.access_token('user')}, status: :ok if @current_user
    render json: { message: 'Not Authorized' }, status: 401 unless @current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :agent, :password, :password_confirmation, :access_token)
  end

  def update_params
    params.require(:user).permit(:name, :email)
  end
end
