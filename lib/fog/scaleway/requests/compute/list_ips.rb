module Fog
  module Scaleway
    class Compute
      class Real
        def list_ips
          get('/ips')
        end
      end

      class Mock
        def list_ips
          ips = data[:ips].values

          response(status: 200, body: { 'ips' => ips })
        end
      end
    end
  end
end
