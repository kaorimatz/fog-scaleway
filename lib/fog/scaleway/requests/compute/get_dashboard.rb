module Fog
  module Scaleway
    class Compute
      class Real
        def get_dashboard
          get('/dashboard')
        end
      end
    end
  end
end
