class AddUserIdToBucketlists < ActiveRecord::Migration
  def change
    add_column :bucketlists, :user_id, :string
  end
end
