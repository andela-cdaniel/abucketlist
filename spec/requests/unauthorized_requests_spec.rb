require "rails_helper"

RSpec.describe "Unauthorized requests to API", type: :request do
  describe "Logout" do
    context "When user doesn't pass in any authorization token" do
      it "returns a message informing the user that no token was passed" do
        get auth_logout_path, {}, { "Accept" => "application/json" }

        expect(response).to have_http_status(422)

        expect(message_body).to match_array(
                                              ["Please match the authorization header format",
                                               "https://github.com/andela-cdaniel/blist"]
                                           )
      end
    end

    context "When user passes in an invalid authorization token" do
      it "returns a message informing the user to pass in a valid token" do
        get auth_logout_path, {}, {
                                    "Authorization" => "Token token=randominvalidtoken",
                                    "Accept" => "application/json"
                                  }

        expect(response).to have_http_status(401)

        expect(message_body).to match_array(
                                              ["Please pass in a valid token in the authorization header",
                                               "https://github.com/andela-cdaniel/blist"]
                                           )
      end
    end
  end

  describe "Accessing bucketlists" do
    context "When user doesn't pass in any authorization token" do
      it "returns a message informing the user that no token was passed" do
        get auth_logout_path, {}, { "Accept" => "application/json" }

        expect(response).to have_http_status(422)

        expect(message_body).to match_array(
                                              ["Please match the authorization header format",
                                               "https://github.com/andela-cdaniel/blist"]
                                           )
      end
    end

    context "When user passes in an invalid authorization token" do
      it "returns a message informing the user to pass in a valid token" do
        get auth_logout_path, {}, {
                                    "Authorization" => "Token token=randominvalidtoken",
                                    "Accept" => "application/json"
                                  }

        expect(response).to have_http_status(401)

        expect(message_body).to match_array(
                                              ["Please pass in a valid token in the authorization header",
                                               "https://github.com/andela-cdaniel/blist"]
                                           )
      end
    end
  end
end
