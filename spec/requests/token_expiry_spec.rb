require "rails_helper"

RSpec.describe "Authorization token expiry", type: :request do
  subject(:user) { User.create(username: username, password: password, logged_in: true) }
  let(:username) { "Ikem" }
  let(:password) { "securepassword" }
  let(:data) { User.generate_jwt_token(user, true) }

  describe "User tries to access API with expired token" do
    it "Doesn't give the user access to the API and informs the user that the token has expired" do
      get api_v1_bucketlists_path, {},
                                   {
                                      "Accept" => "application/json",
                                      "Authorization" => "Token token=#{data[:token]}"
                                   }

      expect(response).to have_http_status(401)
      expect(message_body).to match_array([
                                            "Sorry, you don't have access to this content",
                                            "The token passed in has expired, please login again"]
                                         )
    end
  end
end
