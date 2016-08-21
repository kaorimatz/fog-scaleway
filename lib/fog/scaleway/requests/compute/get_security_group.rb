module Fog
  module Scaleway
    class Compute
      class Real
        def get_security_group(security_group_id)
          get("/security_groups/#{security_group_id}")
        end
      end

      class Mock
        def get_security_group(security_group_id)
          security_group = lookup(:security_groups, security_group_id)

          response(status: 200, body: { 'security_group' => security_group })
        end
      end
    end
  end
end
