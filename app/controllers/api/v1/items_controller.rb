class Api::V1::ItemsController < ApplicationController
  include CurrentBucketList

  before_action :authorize

  def create
    requested_list = fetch_bucketlist_item(params[:bucketlist_id])
    item = requested_list.items.new(name: item_name[:name])
    if item.save
      render json: item, status: :created
    else
      render json: item.errors, status: :unprocessable_entity
    end
  end

  private

  def item_name
    params.permit(:name)
  end

  def save_bucketlist_item(current_list, name)
    
  end
end
