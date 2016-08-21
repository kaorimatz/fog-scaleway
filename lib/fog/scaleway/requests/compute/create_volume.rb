module Fog
  module Scaleway
    class Compute
      class Real
        def create_volume(name, volume_type, options)
          if options[:size].nil? && options[:base_volume].nil? && options[:base_snapshot].nil?
            raise ArgumentError, 'size, base_volume or base_snapshot are required to create a volume'
          end

          body = {
            organization: @organization,
            name: name,
            volume_type: volume_type
          }

          if !options[:size].nil?
            body[:size] = options[:size]
          elsif !options[:base_volume].nil?
            body[:base_volume] = options[:base_volume]
          else
            body[:base_snapshot] = options[:base_snapshot]
          end

          create('/volumes', body)
        end
      end

      class Mock
        def create_volume(name, volume_type, options)
          if options[:size].nil? && options[:base_volume].nil? && options[:base_snapshot].nil?
            raise ArgumentError, 'size, base_volume or base_snapshot are required to create a volume'
          end

          body = {
            organization: @organization,
            name: name,
            volume_type: volume_type
          }

          if !options[:size].nil?
            body[:size] = options[:size]
          elsif !options[:base_volume].nil?
            body[:base_volume] = options[:base_volume]
          else
            body[:base_snapshot] = options[:base_snapshot]
          end

          body = jsonify(body)

          creation_date = now

          if body['size']
            size = body['size']
          elsif body['base_volume']
            base_volume = lookup(:volumes, body['base_volume'])

            server_id = base_volume['server'] && base_volume['server']['id']
            server = lookup(:servers, server_id) if server_id
            in_use = server && server['state'] != 'stopped'

            raise_invalid_request_error('Base volume is in use') if in_use

            size = base_volume['size']
          elsif body['base_snapshot']
            base_snapshot = lookup(:snapshots, body['base_snapshot'])
            size = base_snapshot['size']
          end

          volume = {
            'size' => size,
            'name' => body['name'],
            'modification_date' => creation_date,
            'organization' => body['organization'],
            'export_uri' => nil,
            'creation_date' => creation_date,
            'id' => Fog::UUID.uuid,
            'volume_type' => body['volume_type'],
            'server' => nil
          }

          data[:volumes][volume['id']] = volume

          response(status: 201, body: { 'volume' => volume })
        end
      end
    end
  end
end
