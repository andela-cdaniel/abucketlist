module CurrentBucketList
  extend ActiveSupport::Concerns
  
  def fetch_bucketlist_item(num)
    current_user_bucketlists = map_id_to_current_user_list(current_user.bucketlists)
    index = num.to_i - 1
    current_user_bucketlists[index] unless index < 0
  end
end