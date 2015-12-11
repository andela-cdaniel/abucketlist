require "rails_helper"

RSpec.describe "Deleting a bucketlist", type: :request do
  subject(:user) do
    User.create(username: username, password: password, logged_in: true)
  end

  let(:username) { "Ikem" }
  let(:password) { "securepassword" }
  let(:data) { User.generate_jwt_token(user) }

  describe "User deletes a bucketlist item" do
    context "When user makes a delete request to an endpoint that exists" do
      it "Deletes the bucketlist with the id passed in as a parameter" do
        generate_items_for(user, 2)

        expect(user.bucketlists.first.items.all.length).to eql(2)

        delete api_v1_bucketlist_item_path(1, id: 1), {},
               "Accept" => "application/json",
               "Authorization" => "Token token=#{data[:token]}"

        expect(response).to have_http_status(200)
        expect(response_body[:item_name]).to eql("Item1")
        expect(response_body[:message]).to eql("Item deleted from bucketlist")
        expect(user.reload.bucketlists.first.items.all.length).to eql(1)
      end
    end

    context "When user makes a delete request to an
              endpoint that doesn't exist" do
      it "Returns not found if the bucketlist
            containing the item was not found" do
        delete api_v1_bucketlist_item_path(1, id: 1), {},
               "Accept" => "appplication/json",
               "Authorization" => "Token token=#{data[:token]}"

        expect(response).to have_http_status(404)
        expect(response_body[:message]).to eql("Bucket list was not found")
      end

      it "Returns not found if the specified bucketlist item was not found" do
        generate_items_for(user, 1)

        delete api_v1_bucketlist_item_path(1, id: 24), {},
               "Accept" => "application/json",
               "Authorization" => "Token token=#{data[:token]}"

        expect(response).to have_http_status(404)
        expect(response_body[:message]).to eql(
          "No item with that id found in the bucketlist"
        )
      end
    end
  end
end
