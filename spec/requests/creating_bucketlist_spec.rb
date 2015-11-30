require "rails_helper"

RSpec.describe "Creating a bucketlist", type: :request do
  subject(:user) { User.create(username: username, password: password, logged_in: true) }
  let(:username) { "Ikem" }
  let(:password) { "securepassword" }
  let(:data) { User.generate_jwt_token(user) }

  describe "User creates a bucetlist" do
    context "When user passes in valid parameters as part of the request" do
      let(:bucket_name) { "Bucket1" }
      it "Creates a new bucketlist" do
        post api_v1_bucketlists(name: bucket_name), {},
                                                      {
                                                        "Accept" => "application/json",
                                                        "Authorization" => "Token token=#{data[:token]}"
                                                      }

        expect(response).to have_http_status(201)
        expect(response_body[:bucketlist][:name]).to eql(bucket_name)
      end
    end

    context "When user passes invalid or no parameters as part of the request" do
      it "Doesn't create a bucket list when no parameter is passed in" do
        post api_v1_bucketlists, {}, {
                                      "Accept" => "application/json",
                                      "Authorization" => "Token token=#{data[:token]}"
                                     }

        expect(response).to have_http_status(422)
        expect(response_body[:message]).to eql("Please match the authorization header format")
      end

      it "Doesn't process the logout request when invalid token is passed in" do
        get auth_logout_path, {}, {
                                    "Accept" => "application/json",
                                    "Authorization" => "Token token=123456invalid"
                                  }

        expect(response).to have_http_status(401)
        expect(response_body[:message]).to eql("Please pass in a valid token in the authorization header")
      end
    end
  end
end
