require "rails_helper"

RSpec.describe "Retrieving a bucketlist", type: :request do
  subject(:user) do
    User.create(username: username, password: password, logged_in: true)
  end

  let(:username) { "Ikem" }
  let(:password) { "securepassword" }
  let(:data) { User.generate_jwt_token(user) }

  describe "User requests for all bucketlist" do
    it "Retrieves all bucketlists belonging to user" do
      generate_bucketlists_for(user, 20)

      get api_v1_bucketlists_path, {},
          "Accept" => "application/json",
          "Authorization" => "Token token=#{data[:token]}"

      expect(response).to have_http_status(200)
      expect(response_body[:bucketlists].length).to eql(20)
    end
  end

  describe "User requests for one bucketlist" do
    it "Retrieves the specified bucketlist belonging to user" do
      generate_bucketlists_for(user, 20)

      get api_v1_bucketlist_path(1), {},
          "Accept" => "application/json",
          "Authorization" => "Token token=#{data[:token]}"

      expect(response).to have_http_status(200)
      expect(response_body[:bucketlist][:id]).to eql(1)
    end
  end

  it "Returns not found if the bucketlist wasn't found" do
    get api_v1_bucketlist_path(20), {},
        "Accept" => "application/json",
        "Authorization" => "Token token=#{data[:token]}"

    expect(response).to have_http_status(404)
    expect(response_body[:message]).to eql("Bucket list was not found")
  end
end
