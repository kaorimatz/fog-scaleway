module Fog
  module Scaleway
    class Compute
      class Real
        def get_container(container_id)
          get("/containers/#{container_id}")
        end
      end
    end
  end
end
