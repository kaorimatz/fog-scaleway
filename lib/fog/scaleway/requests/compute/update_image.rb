module Fog
  module Scaleway
    class Compute
      class Real
        def update_image(image_id, body)
          update("/images/#{image_id}", body)
        end
      end

      class Mock
        def update_image(image_id, body)
          body = jsonify(body)

          image = lookup(:images, image_id)

          default_bootscript = case body['default_bootscript']
                               when Hash
                                 lookup(:bootscripts, body['default_bootscript']['id'])
                               when String
                                 lookup(:bootscripts, body['default_bootscript'])
                               end

          image['default_bootscript'] = default_bootscript
          image['name'] = body['name']
          image['arch'] = body['arch']

          response(status: 200, body: { 'image' => image })
        end
      end
    end
  end
end
