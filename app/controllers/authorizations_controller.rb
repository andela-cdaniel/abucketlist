class AuthorizationsController < ApplicationController
  def create
    user = User.authorize(login_params)
    token = User.generate_jwt_token(user) if user

    if user && !user.logged_in
      login(user)
      render json: { message: "Logged in", information: token }, status: :ok
    elsif user && user.logged_in
        render json: { message: "You are already logged in", information: token }, status: :ok
    else
      render json: { message: "Invalid credentials" }, status: :unprocessable_entity
    end
  end

  def destroy
    if request.authorization =~ valid_authorization_header_format
      begin
        token = request.authorization.split("=").last
        payload = JwtTokens.decode(token).first
        user = User.find(payload["user_id"])
        logout(user)
        render json: { 
                        user: user.username,
                        message: "Successfully logged out"
                     },
               status: :ok
      rescue JWT::DecodeError
        render json: { 
                        message: "Please pass in a valid token in the authorization header",
                        documentation: documentation_link
                     },
               status: :unauthorized
      end
    else
      render json: { 
                      message: "Please match the authorization header format",
                      documentation: documentation_link
                   },
             status: :unprocessable_entity
    end
  end

  private

  def login_params
    params.permit(:username, :password)
  end
end
