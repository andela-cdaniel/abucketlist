require "rails_helper"

RSpec.describe "Deleting a bucketlist", type: :request do
  subject(:user) { User.create(username: username, password: password, logged_in: true) }
  let(:username) { "Ikem" }
  let(:password) { "securepassword" }
  let(:data) { User.generate_jwt_token(user) }

  describe "User deletes a bucketlist" do
    context "When user makes a delete request to an endpoint that exists" do
      it "Deletes the bucketlist with the id passed in as a parameter" do
        generate_bucketlists_for(user, 2)

        expect(user.bucketlists.length).to eql(2)

        delete api_v1_bucketlist_path(1), {},
                                          { "Accept" => "application/json",
                                            "Authorization" => "Token token=#{data[:token]}"
                                          }
        expect(response).to have_http_status(200)
        expect(response_body[:bucketlist_name]).to eql("Bucket1")
        expect(response_body[:message]).to eql("Bucket list and all its associated items deleted")
        expect(user.reload.bucketlists.length).to eql(1)
      end
    end

    context "When user makes a delete request to an endpoint that doesn't exist" do
      it "Returns not found if the bucketlist wasn't found" do
        delete api_v1_bucketlist_path(1), {},
                                          { "Accept" => "appplication/json",
                                            "Authorization" => "Token token=#{data[:token]}"
                                          }
        expect(response).to have_http_status(404)
        expect(response_body[:message]).to eql("Bucket list was not found")
      end
    end
  end
end
