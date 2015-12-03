class Item < ActiveRecord::Base
  belongs_to :bucketlist

  VALID_CHARACTERS = /\A[a-z0-9\s]+\z/i

  before_save { self.name = name.capitalize }

  validates :name,
            presence: true,
            length: { in: 4..144 },
            format: { with: VALID_CHARACTERS },
            uniqueness: { case_sensitive: false, scope: :bucketlist_id }

  validates :bucketlist_id, presence: true
end
