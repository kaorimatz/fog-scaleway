module Fog
  module Scaleway
    class Compute
      class Images < Fog::Collection
        model Fog::Scaleway::Compute::Image

        def all
          images = service.list_images.body['images'] || []
          load(images)
        end

        def get(identity)
          if (image = service.get_image(identity).body['image'])
            new(image)
          end
        rescue Fog::Scaleway::Compute::UnknownResource
          nil
        end
      end
    end
  end
end
