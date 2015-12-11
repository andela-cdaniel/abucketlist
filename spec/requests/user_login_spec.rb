require "rails_helper"

RSpec.describe "Logging in to an account", type: :request do
  subject(:user) { User.create(username: username, password: password) }
  let(:username) { "Ikem" }
  let(:password) { "securepassword" }

  describe "User logs in to account" do
    context "When user passes in valid credentials as part of the request" do
      it "Logs a user into the application" do
        post auth_login_path(username: user.username, password: user.password),
             {},
             "Accept" => "application/json"

        expect(response).to have_http_status(200)
        expect(response_body[:message]).to eql("Logged in")
        expect(response_body[:information][:user]).to eql("ikem")
        expect(response_body[:information][:token]).to be_present
        expect(response_body[:information][:expires_on]).to be_present

        expect(user.reload.logged_in).to be true

        post auth_login_path(username: user.username, password: user.password),
             {},
             "Accept" => "application/json"

        expect(response).to have_http_status(200)
        expect((parse_json response.body)[:message]).to eql(
          "You are already logged in"
        )
      end
    end

    context "When user passes invalid credentials as part of the request" do
      let(:username) { "unknown" }
      let(:password) { "fakepassword" }
      it "Doesn't grant the user access to the API" do
        post auth_login_path(username: username, password: password),
             {},
             "Accept" => "application/json"

        expect(response).to have_http_status(422)
        expect(response_body[:message]).to eql("Invalid credentials")
      end
    end
  end
end
