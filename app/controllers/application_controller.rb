class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::Serialization

  attr_reader :current_user

  private

  def authorize
    authorize_token || revoke_access(@reason)
  end

  def authorize_token
    authenticate_with_http_token do |token, options|
      begin
        payload = JwtTokens.decode(token).first
        @current_user = User.find(payload["user_id"])
        @current_user.logged_in ? true : false
      rescue JWT::ExpiredSignature
        @reason = "The token passed in has expired, please login again"
        false
      rescue JWT::DecodeError
        @reason = "The token passed in was invalid"
        false
      end
    end
  end

  def revoke_access(reason)
    render json:
            {
              message: "Sorry, you don't have access to this content",
              reason: reason || "No logged in user found with that token"
            },
            status: :unauthorized
  end

  def valid_authorization_header_format
    /\AToken\stoken=[\w\.\-]+\z/
  end

  def login(user)
    User.login(user)
  end

  def logout(user)
    User.logout(user)
  end

  def documentation_link
    "https://andela-cdaniel.github.io/slate"
  end
end
