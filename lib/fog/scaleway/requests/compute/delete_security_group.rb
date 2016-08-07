module Fog
  module Scaleway
    class Compute
      class Real
        def delete_security_group(security_group_id)
          delete("/security_groups/#{security_group_id}")
        end
      end
    end
  end
end
