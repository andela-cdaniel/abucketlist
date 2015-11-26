class Bucketlist < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy

  VALID_CHARACTERS = /\A[a-z0-9\s]+\z/i

  before_save { self.name = name.capitalize }

  validates :name,
            presence: true,
            format: { with: VALID_CHARACTERS },
            uniqueness: { case_sensitive: false, scope: :created_by }

  validates :created_by, presence: true
end
