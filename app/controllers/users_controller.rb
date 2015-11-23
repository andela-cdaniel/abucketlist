class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    User.generate_api_key(user)
    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:username, :password)
  end
end
