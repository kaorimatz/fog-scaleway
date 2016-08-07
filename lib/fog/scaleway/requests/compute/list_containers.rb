module Fog
  module Scaleway
    class Compute
      class Real
        def list_containers
          get('/containers')
        end
      end
    end
  end
end
