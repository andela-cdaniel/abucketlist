require "rails_helper"

RSpec.describe "Searching API json responses", type: :request do
  subject(:user) do
    User.create(username: username, password: password, logged_in: true)
  end

  let(:username) { "Ikem" }
  let(:password) { "securepassword" }
  let(:data) { User.generate_jwt_token(user) }

  describe "User searches for items by name" do
    context "When the item is found" do
      it "Returns search results matching search query" do
        generate_bucketlists_for(user, 30)

        get api_v1_bucketlists_path(q: "bucket1"), {},
            "Accept" => "application/json",
            "Authorization" => "Token token=#{data[:token]}"

        expect(response).to have_http_status(200)
        expect(all_true?(response_body[:bucketlists])).to be true
      end
    end

    context "When the item is not found" do
      it "Returns a message informing the user that the item wasn't found" do
        generate_bucketlists_for(user, 20)

        get api_v1_bucketlists_path(q: "awesome"), {},
            "Accept" => "application/json",
            "Authorization" => "Token token=#{data[:token]}"
        
        expect(response).to have_http_status(200)
        expect((response_body[:message])).to eql(
          "No result found matching awesome"
        )
      end
    end
  end
end
