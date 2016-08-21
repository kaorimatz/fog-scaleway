module Fog
  module Scaleway
    class Compute
      class Real
        def list_snapshots
          get('/snapshots')
        end
      end

      class Mock
        def list_snapshots
          snapshots = data[:snapshots].values

          response(status: 200, body: { 'snapshots' => snapshots })
        end
      end
    end
  end
end
