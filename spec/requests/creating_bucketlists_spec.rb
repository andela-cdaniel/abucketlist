require "rails_helper"

RSpec.describe "Creating a bucketlist", type: :request do
  subject(:user) { User.create(username: username, password: password, logged_in: true) }
  let(:username) { "Ikem" }
  let(:password) { "securepassword" }
  let(:data) { User.generate_jwt_token(user) }

  describe "User creates a bucketlist" do
    context "When user passes in valid parameters as part of the request" do
      let(:bucket_name) { "Bucket1" }
      it "Creates a new bucketlist" do
        post api_v1_bucketlists_path(name: bucket_name), {},
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
        post api_v1_bucketlists_path, {}, {
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

      it "Doesn't create a bucket list when an invalid parameter is passed in" do
        post api_v1_bucketlists_path(name: "----"), {}, {
                                    "Accept" => "application/json",
                                    "Authorization" => "Token token=#{data[:token]}"
                                  }

        expect(response).to have_http_status(422)
        expect(response_body[:name]).to match_array(["is invalid"])
      end
    end
  end
end
