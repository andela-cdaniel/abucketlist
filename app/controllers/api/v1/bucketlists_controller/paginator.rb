class Api::V1::BucketlistsController
  class Paginator
    def initialize(params, search_query={})
      @page = params[:page]
      @limit = params[:limit]
      @search_query = search_query[:q]
    end

    def set_limit(limit)
      case
      when limit.nil?
        20
      when limit.to_i < 1
        0
      when limit.to_i > 100
        100
      else
        limit.to_i
      end
    end

    def set_offset_from(page, limit)
      case
      when page.to_i < 2
        0
      else
        (page.to_i - 1) * limit
      end
    end

    def limit
      set_limit(@limit)
    end

    def offset
      set_offset_from(@page, limit)
    end

    def paginate(query)
      result = query.offset(offset).limit(limit)
      set_meta_information(result, query)
    end

    def paginate_with_search(query)
      query = query.where("name like ?", "%#{@search_query}%")
      result = query.offset(offset).limit(limit)
      set_meta_information(result, query)
    end

    def set_meta_information(result, query)
      total_pages = (query.length.to_f / limit.to_f).ceil
      total_count = query.length

      current_page = @page.to_i
      next_page = (current_page + 1) > total_pages ? nil : (current_page + 1)

      meta_info = {
                    meta: {
                      current_page: current_page,
                      next_page: next_page,
                      total_pages: total_pages,
                      total_count: total_count
                    }
                  }
      result << meta_info unless result.blank?
    end
  end
end
