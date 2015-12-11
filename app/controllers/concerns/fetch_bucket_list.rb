module FetchBucketList
  extend ActiveSupport::Concerns

  def requested_list(id)
    current_user.bucketlists.find_by_id(id)
  end
end
