module Fog
  module Scaleway
    class Compute
      class Real
        def list_bootscripts
          get('/bootscripts')
        end
      end
    end
  end
end
