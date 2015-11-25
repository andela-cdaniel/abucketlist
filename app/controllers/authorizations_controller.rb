class AuthorizationsController < ApplicationController
  def create
    user = User.authorize(login_params)
    token = User.generate_jwt_token(user)
    if user && !user.logged_in
      User.login(user)
      render json: token, status: :ok
    elsif user && user.logged_in
        render json: { 
                      message: "You are already logged in",
                      information: token
                      },
                      status: :ok
    else
      render json: { message: "Invalid credentials" }, status: :unprocessable_entity
    end
  end

  def destroy
    #User.logout(user)
  end

  private

  def login_params
    params.permit(:username, :password)
  end
end
