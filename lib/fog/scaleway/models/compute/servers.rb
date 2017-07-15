module Fog
  module Scaleway
    class Compute
      class Servers < Fog::Collection
        model Fog::Scaleway::Compute::Server

        def all
          servers = service.list_servers.body['servers'] || []
          load(servers)
        end

        def get(identity)
          if (server = service.get_server(identity).body['server'])
            new(server)
          end
        rescue Fog::Scaleway::Compute::UnknownResource
          nil
        end

        def bootstrap(new_attributes = {})
          require 'securerandom'
          name = "scw-#{SecureRandom.hex(3)}"

          public_ip = new_attributes[:public_ip]

          public_ip = service.ips.create(new_attributes) if public_ip.nil?

          defaults = {
            name: name,
            image: '75c28f52-6c64-40fc-bb31-f53ca9d02de9',
            dynamic_ip_required: false,
            public_ip: public_ip
          }

          server = create(defaults.merge(new_attributes))

          server.poweron(false)

          server.wait_for { sshable? }

          server
        end
      end
    end
  end
end
