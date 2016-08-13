module Fog
  module Scaleway
    class Compute
      class Real
        def list_bootscripts(filters = {})
          get('/bootscripts', filters)
        end
      end
    end
  end
end
