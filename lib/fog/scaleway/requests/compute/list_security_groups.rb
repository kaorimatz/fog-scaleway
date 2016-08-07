module Fog
  module Scaleway
    class Compute
      class Real
        def list_security_groups
          get('/security_groups')
        end
      end
    end
  end
end
