require "rails_helper"

RSpec.describe "Invalid requests to API", type: :request do
  describe "Root path" do
    context "When a request doesn't match any available routes" do
      it "returns a message informing the user that an
            invalid request was made" do
        get "/:not_found", {}, "Accept" => "application/json"

        expectations_for_invalid_request
      end
    end
  end
end
