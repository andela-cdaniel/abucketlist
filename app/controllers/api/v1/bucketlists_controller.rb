class Api::V1::BucketlistsController < ApplicationController
  before_action :authorize
  
  def index
    render json: current_user.bucketlists, status: :ok
  end

  def create
    bucketlist = Bucketlist.new(bucket_name)
    bucketlist.created_by = current_user.id
    if bucketlist.save
      render json: bucketlist, status: :created
    else
      render json: bucketlist.errors, status: :unprocessable_entity
    end
  end

  def show
    requested_list = fetch_bucket_list_item(params[:id])
    if requested_list
      render json: requested_list, status: :ok
    else
      render json: { message: "Bucket list was not found" }, status: :not_found
    end
  end

  def update
    requested_list = fetch_bucket_list_item(params[:id])
    if requested_list
      require "pry"; binding.pry
    else
      head 200
    end
  end

  private

  def bucket_name
    params.permit(:name)
  end

  def fetch_bucket_list_item(num)
    current_user_bucketlists = current_user.bucketlists.to_a
    index = num.to_i - 1
    current_user_bucketlists[index] unless index < 0
  end
end
