module Api
  module V1
    class BucketlistsController
      class Designator
        attr_reader :pagination_params, :search_param

        def initialize(pagination_params, search_param)
          @pagination_params = pagination_params
          @search_param = search_param
        end

        def self.get(pagination_params, search_param)
          new(pagination_params, search_param)
        end

        def search_and_paginate(record, &block)
          if search_param.present? && pagination_params.present?
            block.call(Paginator.new(pagination_params, search_param).
              paginate_with_search(record))
          end
        end

        def search(record, &block)
          if search_param.present?
            block.call(Search.for(search_param).within(record))
          end
        end

        def paginate(record, &block)
          if pagination_params.present?
            block.call(Paginator.new(pagination_params).paginate(record))
          end
        end

        def show_all(record, &block)
          block.call(record)
        end

        def handle_requests_for(record, &block)
          search_and_paginate(record, &block) ||
            search(record, &block) ||
            paginate(record, &block) ||
            show_all(record, &block)
        end
      end
    end
  end
end
