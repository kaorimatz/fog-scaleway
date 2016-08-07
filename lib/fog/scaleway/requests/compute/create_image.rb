module Fog
  module Scaleway
    class Compute
      class Real
        def create_image(name, arch, root_volume)
          create('/images', organization: @organization,
                            name: name,
                            arch: arch,
                            root_volume: root_volume)
        end
      end
    end
  end
end
