class RemoveUserIdFromBucketlists < ActiveRecord::Migration
  def change
    remove_column :bucketlists, :user_id
  end
end
