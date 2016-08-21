module Fog
  module Scaleway
    class Compute
      class Real
        def list_containers
          get('/containers')
        end
      end

      class Mock
        def list_containers
          containers = data[:containers].values

          response(status: 200, body: { 'containers' => containers })
        end
      end
    end
  end
end
