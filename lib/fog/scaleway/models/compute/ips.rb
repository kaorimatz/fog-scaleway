module Fog
  module Scaleway
    class Compute
      class Ips < Fog::Collection
        model Fog::Scaleway::Compute::Ip

        def all
          ips = service.list_ips.body['ips'] || []
          load(ips)
        end

        def get(identity)
          if (ip = service.get_ip(identity).body['ip'])
            new(ip)
          end
        rescue Fog::Scaleway::Compute::UnknownResource
          nil
        end
      end
    end
  end
end
