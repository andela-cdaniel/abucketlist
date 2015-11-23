class Item < ActiveRecord::Base
  belongs_to :bucketlist

  VALID_CHARACTERS = /\A[a-z0-9\s]+\z/i
  
  validates :name, presence: true, format: { with: VALID_CHARACTERS }
end
