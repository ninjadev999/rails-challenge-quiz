class ApplicationController < ActionController::API
  include Concerns::SaveError
  # include ExceptionHandler

  attr_accessor :current_user

  before_action :set_current_user, :authenticate_request

  rescue_from ActionController::RoutingError, with: :route_not_found_handler
  skip_before_action :set_current_user, :authenticate_request, only: [:route_not_found]

  def route_not_found
    raise ActionController::RoutingError.new(params[:path])
  end

  private

  def set_current_user
    # TODO create the JsonWebToken method first
    # in lib/util/json_web_token.rb
    token = Util::JsonWebToken.decode(request.headers[:token])
    # If the token is present and the user agent
    # is the same as the the one in the token, find
    # the user by the user_id inside the token hash
    # and set the @current_user to that user
    if token.present? and token['user_id'].present? and token['user_agent'].present?
      user = User.where(id: token['user_id']).first
      @current_user = user if user.agent == token['user_agent']
    end
  end

  def authenticate_request
    # TODO if no current_user exit request and
    # send response json with a message and
    # unauthorized status code
    render json: { message: 'Not Authorized' }, status: 401 unless @current_user
  end

  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    end
      raise(ExceptionHandler::MissingToken, Message.missing_token)
  end
  def route_not_found_handler
    return render json: { message: 'Route not found' }, status: :not_found
  end
end
