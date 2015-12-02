require "rails_helper"

RSpec.describe "Searching API json responses", type: :request do
  subject(:user) { User.create(username: username, password: password, logged_in: true) }
  let(:username) { "Ikem" }
  let(:password) { "securepassword" }
  let(:data) { User.generate_jwt_token(user) }

  describe "User searches for items by name" do
    it "Returns search results matching search query" do
      generate_bucketlists_for(user, 30)

      get api_v1_bucketlists_path(q: "bucket1"),
                                 {},
                                 {
                                   "Accept" => "application/json",
                                    "Authorization" => "Token token=#{data[:token]}"
                                  }

      expect(response).to have_http_status(200)
      expect(response_body[:bucketlists].all? { |b| b[:name].match(/bucket1/i) }).to be true
    end
  end
end
