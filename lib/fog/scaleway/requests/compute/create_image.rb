module Fog
  module Scaleway
    class Compute
      class Real
        def create_image(name, arch, root_volume, options = {})
          body = {
            organization: @organization,
            name: name,
            arch: arch,
            root_volume: root_volume
          }

          body.merge!(options)

          create('/images', body)
        end
      end
    end
  end
end
