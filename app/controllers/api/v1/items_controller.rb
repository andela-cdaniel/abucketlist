class Api::V1::ItemsController < ApplicationController
  include CurrentBucketList

  before_action :authorize

  def create
    requested_list = fetch_bucketlist_item(params[:bucketlist_id])
    if requested_list
      save_item(requested_list, item_params[:name])
    else
      render json: { message: "Bucketlist was not found" }, status: :not_found
    end
  end

  def update
    requested_list = fetch_bucketlist_item(params[:bucketlist_id])
    if requested_list
      item_params[:done].nil? ? vet_item(requested_list, item_params[:name]) :
                                vet_item(requested_list, item_params[:name], item_params[:done])
    else
      render json: { message: "Bucketlist was not found" }, status: :not_found
    end
  end

  private

  def item_params
    params.permit(:name, :done)
  end

  def fetch_specific_item(list, num)
    list = list.to_a
    item = num.to_i - 1
    list[item] unless item < 0
  end

  def save_item(current_list, name)
    item = current_list.items.new(name: name)
    if item.save
      render json: item, status: :created
    else
      render json: item.errors, status: :unprocessable_entity
    end
  end

  def update_item(current_list, name, done)
    if current_list.update(name: name, done: done)
      render json: current_list, status: :ok
    else
      render json: current_list.errors, status: :unprocessable_entity
    end
  end

  def vet_item(current_list, name, done="f")
    accepted_boolean = /\A(f|false)\z|\A(t|true)\z/i
    done = "f" unless done.match(accepted_boolean)
    item = fetch_specific_item(current_list.items.all, params[:id])

    if item
      name = item.name if name.nil?
      update_item(item, name, done)
    else
      render json: { message: "No item with that id found in the bucketlist" },
             status: :not_found
    end
  end
end
