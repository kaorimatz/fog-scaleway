module Fog
  module Scaleway
    class Compute
      class Real
        def get_dashboard # rubocop:disable Naming/AccessorMethodName
          get('/dashboard')
        end
      end

      class Mock
        def get_dashboard # rubocop:disable Naming/AccessorMethodName
          running_servers = data[:servers].select do |_id, s|
            s['state'] == 'running'
          end

          servers_by_types = data[:servers].group_by { |s| s['commercial_type'] }
          servers_count_by_types = Hash[servers_by_types.map { |t, s| [t, s.size] }]

          ips_unused = data[:ips].reject { |ip| ip['server'] }.size

          dashboard = {
            'snapshots_count' => data[:snapshots].size,
            'servers_count' => data[:servers].size,
            'volumes_count' => data[:volumes].size,
            'images_count' => data[:images].size,
            'ips_count' => data[:ips].size,
            'running_servers_count' => running_servers.size,
            'servers_by_types' => servers_count_by_types,
            'ips_unused' => ips_unused
          }

          response(status: 200, body: { 'dashboard' => dashboard })
        end
      end
    end
  end
end
