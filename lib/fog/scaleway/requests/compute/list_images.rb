module Fog
  module Scaleway
    class Compute
      class Real
        def list_images(filters = {})
          get('/images', { organization: @organization }.merge(filters))
        end
      end
    end
  end
end
