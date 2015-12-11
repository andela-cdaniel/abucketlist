require "rails_helper"

RSpec.describe "Updating a Bucketlist item", type: :request do
  subject(:user) do
    User.create(username: username, password: password, logged_in: true)
  end

  let(:username) { "Ikem" }
  let(:password) { "securepassword" }
  let(:data) { User.generate_jwt_token(user) }

  describe "User updates a bucketlist item" do
    context "When user passes in valid parameters as part of the request" do
      let(:item_name) { "New item name" }
      let(:done) { "true" }

      it "Updates a bucketlist item when all parameters are present" do
        generate_items_for(user, 1)

        put api_v1_bucketlist_item_path(1, id: 1, name: item_name, done: done),
            {},
            "Accept" => "application/json",
            "Authorization" => "Token token=#{data[:token]}"

        expect(response).to have_http_status(200)
        expect(response_body[:item][:name]).to eql("New item name")
        expect(response_body[:item][:done]).to be true
      end

      it "Updates a bucketlist item when only the name parameter is present" do
        generate_items_for(user, 1)

        put api_v1_bucketlist_item_path(1, id: 1, name: item_name),
            {},
            "Accept" => "application/json",
            "Authorization" => "Token token=#{data[:token]}"

        expect(response).to have_http_status(200)
        expect(response_body[:item][:name]).to eql("New item name")
        expect(response_body[:item][:done]).to be false
      end

      it "Updates a bucketlist item when only the done parameter is present" do
        generate_items_for(user, 1)

        put api_v1_bucketlist_item_path(1, id: 1, done: done),
            {},
            "Accept" => "application/json",
            "Authorization" => "Token token=#{data[:token]}"

        expect(response).to have_http_status(200)
        expect(response_body[:item][:name]).to eql("Item1")
        expect(response_body[:item][:done]).to be true
      end

      it "Updates a bucketlist item with defaults
            when no parameter is present" do
        generate_items_for(user, 1)

        put api_v1_bucketlist_item_path(1, id: 1),
            {},
            "Accept" => "application/json",
            "Authorization" => "Token token=#{data[:token]}"

        expect(response).to have_http_status(200)
        expect(response_body[:item][:name]).to eql("Item1")
        expect(response_body[:item][:done]).to be false
      end

      it "Updates a bucketlist item with the default
            if the done parameter is invalid" do
        generate_items_for(user, 1)

        put api_v1_bucketlist_item_path(1, id: 1, name: item_name, done: "not"),
            {},
            "Accept" => "application/json",
            "Authorization" => "Token token=#{data[:token]}"

        expect(response).to have_http_status(200)
        expect(response_body[:item][:name]).to eql("New item name")
        expect(response_body[:item][:done]).to be false
      end
    end

    context "When user passes invalid parameters as part of the request" do
      let(:item_name) { "new-_item --" }

      it "Doesn't update a bucketlist item if the name parameter is invalid" do
        generate_items_for(user, 1)

        put api_v1_bucketlist_item_path(1, id: 1, name: item_name),
            {},
            "Accept" => "application/json",
            "Authorization" => "Token token=#{data[:token]}"

        expect(response).to have_http_status(422)
        expect(response_body[:name]).to match_array(["is invalid"])
      end

      it "Returns not found if the bucketlist
            containing the item was not found" do
        put api_v1_bucketlist_item_path(1, id: 1), {},
            "Accept" => "application/json",
            "Authorization" => "Token token=#{data[:token]}"

        expect(response).to have_http_status(404)
        expect(response_body[:message]).to eql("Bucket list was not found")
      end

      it "Returns not found if the specified bucketlist item was not found" do
        generate_items_for(user, 1)

        put api_v1_bucketlist_item_path(1, id: 24), {},
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
