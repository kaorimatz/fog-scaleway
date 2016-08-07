module Fog
  module Scaleway
    class Compute
      class Volumes < Fog::Collection
        model Fog::Scaleway::Compute::Volume

        def all
          volumes = service.list_volumes.body['volumes'] || []
          load(volumes)
        end

        def get(identity)
          if (volume = service.get_volume(identity).body['volume'])
            new(volume)
          end
        rescue Fog::Scaleway::Compute::UnknownResource
          nil
        end
      end
    end
  end
end
