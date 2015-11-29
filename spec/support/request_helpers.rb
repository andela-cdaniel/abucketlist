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
end
