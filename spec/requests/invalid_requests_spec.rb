require "rails_helper"

RSpec.describe "InvalidRequests to API", type: :request do
  describe "GET root path" do
    it "returns a message informing the user that an invalid request was made" do
      get root_path, {}, { "Accept" => "application/json" }

      expect(response).to have_http_status(200)

      body = response_body.map { |key, value| value }
      
      expect(body).to match_array(["Welcome to the bucket list API. An invalid request was made",
                                   "https://github.com/andela-cdaniel/blist"])
    end
  end
end
