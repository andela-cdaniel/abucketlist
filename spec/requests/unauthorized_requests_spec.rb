require "rails_helper"

RSpec.describe "Unauthorized requests to API", type: :request do
  describe "Logout" do
    context "When user doesn't pass in any authorization token" do
      it "returns a message informing the user that no token was passed" do
        get auth_logout_path, {}, "Accept" => "application/json"

        expect(response).to have_http_status(422)

        expect(message_body).to match_array(
          [
            "Please match the authorization header format",
            "https://a-bucketlist.herokuapp.com"
          ]
        )
      end
    end

    context "When user passes in an invalid authorization token" do
      it "returns a message informing the user to pass in a valid token" do
        get auth_logout_path, {},
            "Authorization" => "Token token=randominvalidtoken",
            "Accept" => "application/json"

        expect(response).to have_http_status(401)

        expect(message_body).to match_array(
          [
            "Please pass in a valid token in the authorization header",
            "https://a-bucketlist.herokuapp.com"
          ]
        )
      end
    end
  end

  describe "Accessing bucketlists" do
    context "When user doesn't pass in any authorization token" do
      it "returns a message informing the user that no token was passed" do
        get api_v1_bucketlists_path, {}, "Accept" => "application/json"

        expectations_for_no_token
      end
    end

    context "When user passes in an invalid authorization token" do
      it "returns a message informing the user to pass in a valid token" do
        get api_v1_bucketlists_path, {},
            "Authorization" => "Token token=randominvalidtoken",
            "Accept" => "application/json"

        expectations_for_invalid_token
      end
    end
  end

  describe "Creating bucketlists" do
    context "When user doesn't pass in any authorization token" do
      it "returns a message informing the user that no token was passed" do
        post api_v1_bucketlists_path(name: "bucket1"), {},
             "Accept" => "application/json"

        expectations_for_no_token
      end
    end

    context "When user passes in an invalid authorization token" do
      it "returns a message informing the user to pass in a valid token" do
        post api_v1_bucketlists_path(name: "bucket1"), {},
             "Authorization" => "Token token=randominvalidtoken",
             "Accept" => "application/json"

        expectations_for_invalid_token
      end
    end
  end

  describe "Accessing a specific bucketlist" do
    context "When user doesn't pass in any authorization token" do
      it "returns a message informing the user that no token was passed" do
        get api_v1_bucketlist_path(1), {}, "Accept" => "application/json"

        expectations_for_no_token
      end
    end

    context "When user passes in an invalid authorization token" do
      it "returns a message informing the user to pass in a valid token" do
        get api_v1_bucketlist_path(1), {},
            "Authorization" => "Token token=randominvalidtoken",
            "Accept" => "application/json"

        expectations_for_invalid_token
      end
    end
  end

  describe "Updating a specific bucketlist" do
    context "When user doesn't pass in any authorization token" do
      it "returns a message informing the user that no token was passed" do
        put api_v1_bucketlist_path(1), {}, "Accept" => "application/json"

        expectations_for_no_token
      end
    end

    context "When user passes in an invalid authorization token" do
      it "returns a message informing the user to pass in a valid token" do
        put api_v1_bucketlist_path(1), {},
            "Authorization" => "Token token=randominvalidtoken",
            "Accept" => "application/json"

        expectations_for_invalid_token
      end
    end
  end

  describe "Deleting a specific bucketlist" do
    context "When user doesn't pass in any authorization token" do
      it "returns a message informing the user that no token was passed" do
        delete api_v1_bucketlist_path(1), {}, "Accept" => "application/json"

        expectations_for_no_token
      end
    end

    context "When user passes in an invalid authorization token" do
      it "returns a message informing the user to pass in a valid token" do
        delete api_v1_bucketlist_path(1), {},
               "Authorization" => "Token token=randominvalidtoken",
               "Accept" => "application/json"

        expectations_for_invalid_token
      end
    end
  end

  describe "Creating a specific bucketlist item" do
    context "When user doesn't pass in any authorization token" do
      it "returns a message informing the user that no token was passed" do
        post api_v1_bucketlist_items_path(1), {}, "Accept" => "application/json"

        expectations_for_no_token
      end
    end

    context "When user passes in an invalid authorization token" do
      it "returns a message informing the user to pass in a valid token" do
        post api_v1_bucketlist_items_path(1), {},
             "Authorization" => "Token token=randominvalidtoken",
             "Accept" => "application/json"

        expectations_for_invalid_token
      end
    end
  end

  describe "Updating a specific bucketlist item" do
    context "When user doesn't pass in any authorization token" do
      it "returns a message informing the user that no token was passed" do
        put "/api/v1/bucketlists/1/items/1", {}, "Accept" => "application/json"

        expectations_for_no_token
      end
    end

    context "When user passes in an invalid authorization token" do
      it "returns a message informing the user to pass in a valid token" do
        put "/api/v1/bucketlists/1/items/1", {},
            "Authorization" => "Token token=randominvalidtoken",
            "Accept" => "application/json"

        expectations_for_invalid_token
      end
    end
  end

  describe "Deleting a specific bucketlist item" do
    context "When user doesn't pass in any authorization token" do
      it "returns a message informing the user that no token was passed" do
        delete "/api/v1/bucketlists/1/items/1", {},
               "Accept" => "application/json"

        expectations_for_no_token
      end
    end

    context "When user passes in an invalid authorization token" do
      it "returns a message informing the user to pass in a valid token" do
        delete "/api/v1/bucketlists/1/items/1", {},
               "Authorization" => "Token token=randominvalidtoken",
               "Accept" => "application/json"

        expectations_for_invalid_token
      end
    end
  end
end
