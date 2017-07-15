module Fog
  module Scaleway
    class Compute
      class Real
        def list_product_servers
          get('/products/servers')
        end
      end

      class Mock
        def list_product_servers
          response(status: 200, body: { 'servers' => PRODUCTS['servers'] })
        end
      end
    end
  end
end
