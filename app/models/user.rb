class User < ActiveRecord::Base
  has_many :bucketlists, foreign_key: :created_by, dependent: :destroy
  has_many :items, through: :bucketlists

  has_secure_password

  VALID_USER_NAME = /\A[a-z0-9]+\z/i

  before_save { self.username = username.downcase }

  validates :username,
            presence: true,
            length: { in: 2..50 },
            format: { with: VALID_USER_NAME },
            uniqueness: { case_sensitive: false }

  validates :password,
            presence: true,
            length: { in: 8..255 }

  def self.authorize(credentials = {})
    user = User.find_by_username(credentials[:username].downcase) unless credentials[:username].nil?
    if user && user.authenticate(credentials[:password])
      user
    else
      nil
    end
  end

  def self.login(user)
    user.update_attribute("logged_in", true)
  end

  def self.logout(user)
    user.update_attribute("logged_in", false)
  end

  def self.generate_jwt_token(user)
    expires_at = 12.hours.from_now
    payload = { user_id: user.id, exp: expires_at.to_i }
    {
      user: user.username,
      token: JwtTokens.encode(payload),
      expires_on: expires_at.strftime("%b %e, %Y. %l:%M %P")
    }
  end
end
