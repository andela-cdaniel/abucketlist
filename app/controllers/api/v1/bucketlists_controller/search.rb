class Api::V1::BucketlistsController
  class Search
    attr_reader :query

    def initialize(query)
      @query = query
    end

    def within(list)
      search_result = list.where("name like ?", "%#{query}%")
      search_result.blank? ? 
                           { message: "No result found matching #{query}" } : 
                           search_result
    end
  end
end
