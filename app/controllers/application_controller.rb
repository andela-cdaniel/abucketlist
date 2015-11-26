class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::Serialization

  private

  def authorize
    authorize_token || revoke_access(@reason)  
  end

  def authorize_token
    authenticate_with_http_token do |token, options|
      begin
        response = JwtTokens.decode(token)
        true
      rescue JWT::ExpiredSignature
        @reason = "The token passed in has expired"
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
              reason: reason || "No Authorization token sent"
            },
            status: :unauthorized
  end

  def current_user
    @current_user || nil
  end

  def valid_authorization_header_format
    /Token\stoken=.+/
  end

  def login(user)
    User.login(user)
  end

  def logout(user)
    User.logout(user)
  end

  def documentation_link
    "https://blist.github.io/andela-cdaniel"
  end
end
