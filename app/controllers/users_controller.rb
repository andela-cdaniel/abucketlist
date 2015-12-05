class UsersController < ApplicationController
  def index
    redirect_to documentation_link, status: 302
  end

  def doc
    render json: {
                    message: "Welcome to the bucket list API. An invalid request was made",
                    documentation: documentation_link
                 },
           status: :ok
  end

  def create
    user = User.new(user_params)
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
