require "rails_helper"

RSpec.describe "Paginated json responses", type: :request do
  subject(:user) do
    User.create(username: username, password: password, logged_in: true)
  end

  let(:username) { "Ikem" }
  let(:password) { "securepassword" }
  let(:data) { User.generate_jwt_token(user) }

  describe "User requests for items on a specific page" do
    context "When the user passes in page and limit parameters" do
      it "Returns a response matching the passed in parameters" do
        generate_bucketlists_for(user, 30)

        get api_v1_bucketlists_path(page: "2", limit: 20), {},
            "Accept" => "application/json",
            "Authorization" => "Token token=#{data[:token]}"

        meta = response_body[:bucketlists].pop[:meta]
        expect(response).to have_http_status(200)
        expect(response_body[:bucketlists].length).to eql(10)
        expect(meta[:current_page]).to eql(2)
        expect(meta[:next_page]).to be_nil
        expect(meta[:total_pages]).to eql(2)
        expect(meta[:total_count]).to eql(30)
      end
    end

    context "When the user passes in only a limit parameter" do
      it "Returns amount of records equivalent to the passed in limit" do
        generate_bucketlists_for(user, 30)

        get api_v1_bucketlists_path(limit: 2), {},
            "Accept" => "application/json",
            "Authorization" => "Token token=#{data[:token]}"

        response_body[:bucketlists].pop[:meta]
        expect(response).to have_http_status(200)
        expect(response_body[:bucketlists].length).to eql(2)
      end
    end

    context "When the user passes in only a page parameter" do
      it "The limit defaults to 20 records" do
        generate_bucketlists_for(user, 30)

        get api_v1_bucketlists_path(page: "1"), {},
            "Accept" => "application/json",
            "Authorization" => "Token token=#{data[:token]}"

        meta = response_body[:bucketlists].pop[:meta]
        expect(response).to have_http_status(200)
        expect(response_body[:bucketlists].length).to eql(20)
        expect(meta[:current_page]).to eql(1)
        expect(meta[:next_page]).to eql(2)
        expect(meta[:total_pages]).to eql(2)
        expect(meta[:total_count]).to eql(30)
      end
    end

    context "When the user passes in a limit greater than 100" do
      it "The limit defaults to 100 records per page" do
        generate_bucketlists_for(user, 300)

        get api_v1_bucketlists_path(page: "1", limit: 200), {},
            "Accept" => "application/json",
            "Authorization" => "Token token=#{data[:token]}"

        meta = response_body[:bucketlists].pop[:meta]
        expect(response).to have_http_status(200)
        expect(response_body[:bucketlists].length).to eql(100)
        expect(meta[:current_page]).to eql(1)
        expect(meta[:next_page]).to eql(2)
        expect(meta[:total_pages]).to eql(3)
        expect(meta[:total_count]).to eql(300)
      end
    end

    context "When the user passes in page, limit and search parameters" do
      it "Returns search results as paginated" do
        generate_bucketlists_for(user, 20)
        generate_bucketlists_for(user, 10, "example")

        get api_v1_bucketlists_path(q: "example", page: "1", limit: 10), {},
            "Accept" => "application/json",
            "Authorization" => "Token token=#{data[:token]}"

        meta = response_body[:bucketlists].pop[:meta]
        matched = response_body[:bucketlists].all? do |b|
          b[:name].match(/example/i)
        end
        expect(response).to have_http_status(200)
        expect(response_body[:bucketlists].length).to eql(10)
        expect(matched).to be true
        expect(meta[:current_page]).to eql(1)
        expect(meta[:next_page]).to be_nil
        expect(meta[:total_pages]).to eql(1)
        expect(meta[:total_count]).to eql(10)
      end
    end
  end
end
