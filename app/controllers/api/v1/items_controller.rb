module Api
  module V1
    class ItemsController < ApplicationController
      include FetchBucketList

      before_action :authorize

      def create
        if requested_list(params[:bucketlist_id])
          save_item(requested_list(params[:bucketlist_id]), item_params[:name])
        else
          render json: {
            message: "Bucket list was not found"
          }, status: :not_found
        end
      end

      def update
        if requested_list(params[:bucketlist_id])
          if item_params[:done].nil?
            vet_item(requested_list(params[:bucketlist_id]), item_params[:name])
          else
            vet_item(
              requested_list(params[:bucketlist_id]),
              item_params[:name],
              item_params[:done]
            )
          end
        else
          render json: {
            message: "Bucket list was not found"
          }, status: :not_found
        end
      end

      def destroy
        if requested_list(params[:bucketlist_id])
          delete_item(requested_list(params[:bucketlist_id]))
        else
          render json: {
            message: "Bucket list was not found"
          }, status: :not_found
        end
      end

      private

      def item_params
        params.permit(:name, :done)
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

      def delete_item(current_list)
        item = current_list.items.find_by_id(params[:id])

        if item.nil?
          render json: {
            message: "No item with that id found in the bucketlist"
          }, status: :not_found
        elsif item.destroy
          render json: {
            item_name: item.name,
            message: "Item deleted from bucketlist"
          }, status: :ok
        end
      end

      def vet_item(current_list, name, done = "f")
        accepted_boolean = /\A(f|false)\z|\A(t|true)\z/i

        done = "f" unless done.match(accepted_boolean)

        item = current_list.items.find_by_id(params[:id])

        if item
          name = item.name if name.nil?
          update_item(item, name, done)
        else
          render json: {
            message: "No item with that id found in the bucketlist"
          }, status: :not_found
        end
      end
    end
  end
end
