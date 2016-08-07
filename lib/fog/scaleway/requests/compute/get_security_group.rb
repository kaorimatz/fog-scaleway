module Fog
  module Scaleway
    class Compute
      class Real
        def get_security_group(security_group_id)
          get("/security_groups/#{security_group_id}")
        end
      end
    end
  end
end
