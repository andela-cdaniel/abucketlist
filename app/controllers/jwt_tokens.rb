require "jwt"

class JwtTokens
  def self.encode(payload)
    JWT.encode payload, ENV["secret_key"], "HS256"
  end

  def self.decode(token)
    JWT.decode token, ENV["secret_key"], true, algorithm: "HS256"
  end
end
