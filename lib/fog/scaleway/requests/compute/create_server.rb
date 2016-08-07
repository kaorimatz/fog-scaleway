module Fog
  module Scaleway
    class Compute
      class Real
        def create_server(name, image, volumes, options = {})
          body = {
            organization: @organization,
            name: name,
            image: image,
            volumes: volumes
          }

          body.merge!(options)

          create('/servers', body)
        end
      end
    end
  end
end
