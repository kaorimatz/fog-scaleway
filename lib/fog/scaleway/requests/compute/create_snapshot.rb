module Fog
  module Scaleway
    class Compute
      class Real
        def create_snapshot(name, volume_id)
          create('/snapshots', organization: @organization,
                               name: name,
                               volume_id: volume_id)
        end
      end

      class Mock
        def create_snapshot(name, volume_id)
          body = {
            organization: @organization,
            name: name,
            volume_id: volume_id
          }

          body = jsonify(body)

          base_volume = lookup(:volumes, body['volume_id'])

          server_id = base_volume['server'] && base_volume['server']['id']
          server = lookup(:servers, server_id) if server_id
          in_use = server && server['state'] != 'stopped'

          raise_invalid_request_error('server must be stopped to snapshot') if in_use

          creation_date = now

          snapshot = {
            'state' => 'snapshotting',
            'base_volume' => {
              'id' => base_volume['id'],
              'name' => base_volume['name']
            },
            'name' => body['name'],
            'modification_date' => creation_date,
            'organization' => body['organization'],
            'size' => base_volume['size'],
            'id' => Fog::UUID.uuid,
            'volume_type' => base_volume['volume_type'],
            'creation_date' => creation_date
          }

          data[:snapshots][snapshot['id']] = snapshot

          response(status: 201, body: { 'snapshot' => snapshot })
        end
      end
    end
  end
end
