module CurrentBucketList
  extend ActiveSupport::Concerns
  
  def fetch_bucketlist_item(num)
    current_user_bucketlists = current_user.bucketlists.to_a
    index = num.to_i - 1
    current_user_bucketlists[index] unless index < 0
  end
end