module Api
  module V1
    class BucketlistsController
      class Search
        attr_reader :query

        def initialize(query)
          @query = query[:q]
        end

        def self.for(query)
          new(query)
        end

        def within(list)
          search_result = list.where(
            "LOWER(name) like ?", "%#{query.downcase}%"
          )

          if search_result.blank?
            { message: "No result found matching #{query}" }
          else
            search_result
          end
        end
      end
    end
  end
end
