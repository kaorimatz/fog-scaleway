module Fog
  module Scaleway
    class Compute
      class Real
        def list_security_groups
          get('/security_groups')
        end
      end

      class Mock
        def list_security_groups
          security_groups = data[:security_groups].values

          response(status: 200, body: { 'security_groups' => security_groups })
        end
      end
    end
  end
end
