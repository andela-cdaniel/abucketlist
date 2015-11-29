class Api::V1::BucketlistsController
  class Paginator
    def initialize(page)
      @page = page
    end

    def set_limit(limit=20)
      limit = limit > 100 ? 100 : limit
    end
    
    def set_page(page)
      
    end
  end
end