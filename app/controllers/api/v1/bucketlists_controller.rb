class Api::V1::BucketlistsController < ApplicationController
  include CurrentBucketList
  
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
    requested_list = fetch_bucketlist_item(params[:id])
    if requested_list
      render json: requested_list, status: :ok
    else
      render json: { message: "Bucket list was not found" }, status: :not_found
    end
  end

  def update
    requested_list = fetch_bucketlist_item(params[:id])
    if requested_list
      update_bucketlist(requested_list, bucket_name[:name])
    else
      render json: { message: "Bucket list was not found" }, status: :not_found
    end
  end

  def destroy
    requested_list = fetch_bucketlist_item(params[:id])
    if requested_list
      delete_bucketlist(requested_list)
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
                      bucketlist: current_list,
                      message: "Bucket list and all its associated items deleted"
                   },
             status: :ok
    else
      render json: { message: "An error occurred" }, status: :unprocessable_entity
    end
  end
end
