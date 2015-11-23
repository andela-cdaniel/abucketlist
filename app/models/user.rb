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

  def self.generate_api_key(user)
    user.api_key = SecureRandom.hex
  end
end
