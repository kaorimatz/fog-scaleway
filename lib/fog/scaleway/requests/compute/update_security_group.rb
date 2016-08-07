module Fog
  module Scaleway
    class Compute
      class Real
        def update_security_group(security_group_id, body)
          update("/security_groups/#{security_group_id}", body)
        end
      end
    end
  end
end
