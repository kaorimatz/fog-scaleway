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

      class Mock
        def create_image(name, arch, root_volume, options = {})
          body = {
            organization: @organization,
            name: name,
            arch: arch,
            root_volume: root_volume
          }

          body.merge!(options)

          body = jsonify(body)

          creation_date = now

          root_volume = lookup(:snapshots, body['root_volume'])

          image = {
            'default_bootscript' => body['default_bootscript'],
            'creation_date' => creation_date,
            'name' => body['name'],
            'modification_date' => creation_date,
            'organization' => body['organization'],
            'extra_volumes' => '[]',
            'arch' => body['arch'],
            'id' => Fog::UUID.uuid,
            'root_volume' => {
              'size' => root_volume['size'],
              'id' => root_volume['id'],
              'volume_type' => root_volume['volume_type'],
              'name' => root_volume['name']
            },
            'public' => false
          }

          data[:images][image['id']] = image

          response(status: 201, body: { 'image' => image })
        end
      end
    end
  end
end
