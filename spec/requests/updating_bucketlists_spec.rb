require "rails_helper"

RSpec.describe "Updating a Bucketlist", type: :request do
  subject(:user) { User.create(username: username, password: password, logged_in: true) }
  let(:username) { "Ikem" }
  let(:password) { "securepassword" }
  let(:data) { User.generate_jwt_token(user) }

  describe "User updates a bucketlist" do
    context "When user passes in valid parameters as part of the request" do
      let(:bucketname) { "New bucket" }
      it "Updates a bucketlist" do
        generate_bucketlists_for(user, 1)

        put api_v1_bucketlist_path(1, name: bucketname), {},
                                                         {
                                                           "Accept" => "application/json",
                                                           "Authorization" => "Token token=#{data[:token]}"
                                                         }
        expect(response).to have_http_status(200)
        expect(response_body[:bucketlist][:name]).to eql("New bucket")
      end
    end

    context "When user passes invalid or no parameters as part of the request" do
      let(:bucketname) { "new-_bucket_list--" }
      it "Doesn't update a bucketlist when no parameter is passed in" do
        generate_bucketlists_for(user, 1)

        put api_v1_bucketlist_path(1), {},
                                       {
                                         "Accept" => "application/json",
                                         "Authorization" => "Token token=#{data[:token]}"
                                       }
        expect(response).to have_http_status(422)
        expect(response_body[:name]).to match_array(["can't be blank", "is invalid"])
      end

      it "Doesn't update a bucketlist when an invalid parameter is passed in" do
        generate_bucketlists_for(user, 1)

        put api_v1_bucketlist_path(1, name: bucketname), {},
                                                         {
                                                           "Accept" => "application/json",
                                                           "Authorization" => "Token token=#{data[:token]}"
                                                         }
        expect(response).to have_http_status(422)
        expect(response_body[:name]).to match_array(["is invalid"])
      end

      it "Returns not found if the bucketlist wasn't found" do
        put api_v1_bucketlist_path(90), {},
                                    { "Accept" => "application/json",
                                      "Authorization" => "Token token=#{data[:token]}"
                                    }
        expect(response).to have_http_status(404)
        expect(response_body[:message]).to eql("Bucket list was not found")
      end
    end
  end
end
