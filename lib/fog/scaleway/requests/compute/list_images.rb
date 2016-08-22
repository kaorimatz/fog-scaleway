module Fog
  module Scaleway
    class Compute
      class Real
        def list_images(filters = {})
          get('/images', filters)
        end
      end

      class Mock
        def list_images(filters = {})
          images = data[:images].values

          if (organization = filters[:organization])
            images.select! { |i| i['organization'] == organization }
          end

          if (arch = filters[:arch])
            images.select! { |b| b['arch'] == arch }
          end

          response(status: 200, body: { 'images' => images })
        end
      end
    end
  end
end
