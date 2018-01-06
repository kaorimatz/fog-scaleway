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

      class Mock
        def create_server(name, image, volumes, options = {})
          body = {
            organization: @organization,
            name: name,
            image: image,
            volumes: volumes
          }

          body.merge!(options)

          body = jsonify(body)

          image = lookup(:images, body['image'])

          commercial_type, product_server = lookup_product_server(body.fetch('commercial_type', 'VC1S'))
          raise_invalid_request_error('Validation Error') unless commercial_type

          unless image['arch'] == product_server['arch']
            message = "Image '#{image['id']}' arch is not '#{product_server['arch']}'"
            raise_invalid_request_error(message)
          end

          creation_date = now

          volumes = {}
          body['volumes'].each do |index, volume|
            volume = lookup(:volumes, volume['id'])

            if volume['server']
              message = "volume #{volume['id']} is already attached to a server"
              raise_invalid_request_error(message)
            end

            volumes[index] = volume
          end

          root_volume = image['root_volume']
          volumes['0'] = {
            'size' => root_volume['size'],
            'name' => root_volume['name'],
            'modification_date' => creation_date,
            'organization' => body['organization'],
            'export_uri' => nil,
            'creation_date' => creation_date,
            'id' => Fog::UUID.uuid,
            'volume_type' => root_volume['volume_type'],
            'server' => nil
          }

          public_ip = nil
          if body['public_ip']
            public_ip = lookup(:ips, body['public_ip'])

            public_ip = {
              'dynamic' => false,
              'id' => public_ip['id'],
              'address' => public_ip['address']
            }
          end

          default_bootscript_id = image['default_bootscript']['id']
          bootscript_id = body.fetch('bootscript', default_bootscript_id)
          bootscript = lookup(:bootscripts, bootscript_id)

          dynamic_ip_required = !public_ip && body.fetch('dynamic_ip_required', true)

          enable_ipv6 = body.fetch('enable_ipv6', false)
          if enable_ipv6 && !product_server['network']['ipv6_support']
            raise_invalid_request_error("Cannot enable ipv6 on #{commercial_type}")
          end

          if body['security_group']
            security_group = lookup(:security_groups, body['security_group'])
          else
            security_group = default_security_group
            security_group ||= create_default_security_group
          end

          server = {
            'arch' => image['arch'],
            'bootscript' => bootscript,
            'commercial_type' => commercial_type,
            'creation_date' => creation_date,
            'dynamic_ip_required' => dynamic_ip_required,
            'enable_ipv6' => enable_ipv6,
            'extra_networks' => [],
            'hostname' => body['name'],
            'id' => Fog::UUID.uuid,
            'image' => image,
            'ipv6' => nil,
            'location' => nil,
            'modification_date' => creation_date,
            'name' => body['name'],
            'organization' => body['organization'],
            'private_ip' => nil,
            'public_ip' => public_ip,
            'security_group' => {
              'id' => security_group['id'],
              'name' => security_group['name']
            },
            'state' => 'stopped',
            'state_detail' => '',
            'tags' => body.fetch('tags', []),
            'volumes' => volumes
          }

          data[:servers][server['id']] = server

          data[:volumes][server['volumes']['0']['id']] = server['volumes']['0']

          server['volumes'].each_value do |volume|
            volume['server'] = {
              'id' => server['id'],
              'name' => server['name']
            }
          end

          response(status: 201, body: { 'server' => server })
        end
      end
    end
  end
end
