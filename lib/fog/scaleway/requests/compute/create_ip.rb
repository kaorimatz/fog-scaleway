module Fog
  module Scaleway
    class Compute
      class Real
        def create_ip(options = {})
          body = {
            organization: @organization
          }

          body.merge!(options)

          create('/ips', body)
        end
      end
    end
  end
end
