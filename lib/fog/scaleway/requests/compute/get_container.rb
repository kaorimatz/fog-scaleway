module Fog
  module Scaleway
    class Compute
      class Real
        def get_container(container_id)
          get("/containers/#{container_id}")
        end
      end

      class Mock
        def get_container(container_id)
          container = lookup(:containers, container_id)

          response(status: 200, body: { 'container' => container })
        end
      end
    end
  end
end
