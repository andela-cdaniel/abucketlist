require "rails_helper"

RSpec.describe "Logging out of an account", type: :request do
  subject(:user) { User.create(username: username, password: password, logged_in: true) }
  let(:username) { "Ikem" }
  let(:password) { "securepassword" }
  let(:data) { User.generate_jwt_token(user) }

  describe "User logs out of account" do
    context "When user passes in valid credentials as part of the request" do
      it "Logs a user out of the application" do
        get auth_logout_path, {},
                               {
                                 "Accept" => "application/json",
                                 "Authorization" => "Token token=#{data[:token]}"
                               }

        expect(response).to have_http_status(200)
        expect(response_body[:message]).to eql("Successfully logged out")
        expect(response_body[:user]).to eql("ikem")
      end
    end

    context "When user passes invalid credentials as part of the request" do
      it "Doesn't process the logout request when no token is present" do
        get auth_logout_path, {}, { "Accept" => "application/json" }

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
