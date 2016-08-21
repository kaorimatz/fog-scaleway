module Fog
  module Scaleway
    class Compute
      class Real
        def list_volumes
          get('/volumes')
        end
      end

      class Mock
        def list_volumes
          volumes = data[:volumes].values

          response(status: 200, body: { 'volumes' => volumes })
        end
      end
    end
  end
end
