module Requests
  def message_body
    response_body.map { |key, value| value }
  end

  def expectations_for_invalid_request
    expect(response).to have_http_status(200)

    expect(message_body).to match_array(
                                          ["Welcome to the bucket list API. An invalid request was made",
                                           "https://github.com/andela-cdaniel/blist"]
                                       )
  end

  def expectations_for_no_token
    expect(response).to have_http_status(401)

    expect(message_body).to match_array(
                                          ["Sorry, you don't have access to this content",
                                           "No logged in user found with that token"]
                                       )
  end

  def expectations_for_invalid_token
    expect(response).to have_http_status(401)

    expect(message_body).to match_array(
                                          ["Sorry, you don't have access to this content",
                                           "The token passed in was invalid"]
                                       )
  end

  def generate_bucketlists_for(user, n)
    n.times { |n| Bucketlist.create(name: "bucket#{n + 1}", created_by: user.id) }
  end

  def generate_items_for(user, n)
    list = user.bucketlists.create(name: "Test List")
    n.times { |n| list.items.create(name: "item#{n + 1}") }
  end
end
