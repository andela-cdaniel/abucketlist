class Item < ActiveRecord::Base
  belongs_to :bucketlist

  VALID_CHARACTERS_NAME = /\A[a-z0-9\s]+\z/i

  before_save { self.name = name.capitalize }
  
  validates :name,
            presence: true,
            format: { with: VALID_CHARACTERS_NAME },
            uniqueness: { case_sensitive: false, scope: :bucketlist_id }

  validates :bucketlist_id, presence: true
end
