class AddBucketlistIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :bucketlist_id, :string
  end
end
