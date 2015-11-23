class Bucketlist < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy

  VALID_CHARACTERS = /\A[a-z0-9\s]+\z/i

  validates :name, presence: true, format: { with: VALID_CHARACTERS }
  validates :user_id, presence: true
end
