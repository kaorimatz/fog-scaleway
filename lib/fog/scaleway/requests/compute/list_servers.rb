module Fog
  module Scaleway
    class Compute
      class Real
        def list_servers
          get('/servers')
        end
      end

      class Mock
        def list_servers
          servers = data[:servers].values

          response(status: 200, body: { 'servers' => servers })
        end
      end
    end
  end
end
