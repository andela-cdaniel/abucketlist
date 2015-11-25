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
      rescue JWT::DecodeError
        @reason = "The token passed in was invalid"
        false
      rescue JWT::ExpiredSignature
        @reason = "The token passed in has expired"
        false
      end
    end
  end

  def revoke_access(reason)
    render json: 
            { 
              message: "Sorry, you don't have access to this content",
              reason: reason
            },
            status: :unauthorized
  end

  def current_user
    @current_user || nil
  end
end
