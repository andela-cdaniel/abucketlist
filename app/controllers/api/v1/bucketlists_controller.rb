class Api::V1::BucketlistsController < ApplicationController
  include FetchBucketList
  
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
    if requested_list(params[:id])
      render json: requested_list(params[:id]), status: :ok
    else
      render json: { message: "Bucket list was not found" }, status: :not_found
    end
  end

  def update
    if requested_list(params[:id])
      update_bucketlist(requested_list(params[:id]), bucket_name[:name])
    else
      render json: { message: "Bucket list was not found" }, status: :not_found
    end
  end

  def destroy
    if requested_list(params[:id])
      delete_bucketlist(requested_list(params[:id]))
    else
      render json: { message: "Bucket list was not found" }, status: :not_found
    end
  end

  private

  def bucket_name
    params.permit(:name)
  end

  def update_bucketlist(current_list, name)
    if current_list.update(name: name)
      render json: current_list, status: :ok
    else
      render json: current_list.errors, status: :unprocessable_entity
    end
  end

  def delete_bucketlist(current_list)
    if current_list.destroy
      render json: { 
                      bucketlist_name: current_list.name,
                      message: "Bucket list and all its associated items deleted"
                   },
             status: :ok
    else
      render json: { message: "An error occurred" }, status: :internal_server_error
    end
  end
end
