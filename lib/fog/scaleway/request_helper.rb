module Fog
  module Scaleway
    module RequestHelper
      def create(path, body)
        request(method: :post,
                path: path,
                body: body,
                expects: [201])
      end

      def get(path, query = {})
        request(method: :get,
                path: path,
                query: query,
                expects: [200])
      end

      def update(path, body)
        request(method: :put,
                path: path,
                body: body,
                expects: [200])
      end

      def delete(path)
        request(method: :delete,
                path: path,
                expects: [204])
      end
    end
  end
end
