require "rails_helper"

RSpec.describe "Creating a bucketlist item", type: :request do
  subject(:user) { User.create(username: username, password: password, logged_in: true) }
  let(:username) { "Ikem" }
  let(:password) { "securepassword" }
  let(:data) { User.generate_jwt_token(user) }

  describe "User creates a bucketlist item" do
    context "When user passes in valid parameters as part of the request" do
      let(:item_name) { "Item1" }

      it "Creates a new bucketlist" do
        generate_bucketlists_for(user, 1)

        post api_v1_bucketlist_items_path(1, name: item_name),
                                         {},
                                         {
                                           "Accept" => "application/json",
                                           "Authorization" => "Token token=#{data[:token]}"
                                         }

        expect(response).to have_http_status(201)
        expect(response_body[:item][:id]).to eql(1)
        expect(response_body[:item][:name]).to eql("Item1")
      end
    end

    context "When user passes invalid or no parameters as part of the request" do
      it "Doesn't create a bucket list item when no parameter is passed in" do
        generate_bucketlists_for(user, 1)

        post api_v1_bucketlist_items_path(1), {},
                                              {
                                                "Accept" => "application/json",
                                                "Authorization" => "Token token=#{data[:token]}"
                                              }

        expect(response).to have_http_status(422)
        expect(response_body[:name]).to match_array(
                                                      ["can't be blank",
                                                       "is invalid",
                                                       "is too short (minimum is 4 characters)"]
                                                   )
      end

      it "Doesn't create a bucket list item when an invalid parameter is passed in" do
        generate_bucketlists_for(user, 1)

        post api_v1_bucketlist_items_path(1, name: "----"),
                                         {},
                                         {
                                           "Accept" => "application/json",
                                           "Authorization" => "Token token=#{data[:token]}"
                                         }

        expect(response).to have_http_status(422)
        expect(response_body[:name]).to match_array(["is invalid"])
      end

      it "Returns not found if the bucketlist wasn't found" do
        post api_v1_bucketlist_items_path(20),
                                         {},
                                         { "Accept" => "application/json",
                                           "Authorization" => "Token token=#{data[:token]}"
                                         }
        expect(response).to have_http_status(404)
        expect(response_body[:message]).to eql("Bucket list was not found")
      end
    end
  end
end
