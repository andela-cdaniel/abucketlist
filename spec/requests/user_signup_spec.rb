require "rails_helper"

RSpec.describe "Creating a new account", type: :request do
  describe "User creates a new account" do
    context "When user passes in valid credentials as part of the request" do
      it "creates a new user account" do
        post user_new_path(username: "Ikem", password: "12345678"),
             {},
             "Accept" => "application/json"

        expect(response).to have_http_status(201)

        expect(response_body[:user].length).to eql(3)
        expect(response_body[:user][:id]).to eql(1)
        expect(response_body[:user][:username]).to eql("ikem")
      end
    end

    context "When user passes invalid credentials as part of the request" do
      it "doesn't create a user account" do
        post user_new_path, {}, "Accept" => "application/json"
        expect(response).to have_http_status(422)

        post user_new_path(username: "Ikem"), {}, "Accept" => "application/json"
        expect(response).to have_http_status(422)

        post user_new_path(username: "Ikem-"), {},
             "Accept" => "application/json"
        expect(response).to have_http_status(422)

        post user_new_path(password: "12345678"), {},
             "Accept" => "application/json"
        expect(response).to have_http_status(422)

        post user_new_path(username: "Ikem", password: "12"), {},
             "Accept" => "application/json"
        expect(response).to have_http_status(422)

        post user_new_path(username: "Ikem", password: "12345678"), {},
             "Accept" => "application/json"
        expect(response).to have_http_status(201)

        post user_new_path(username: "Ikem", password: "12345678"), {},
             "Accept" => "application/json"
        expect(response).to have_http_status(422)
      end
    end
  end
end
