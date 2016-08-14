module Fog
  module Scaleway
    class Compute
      class Real
        def create_security_group(name, options = {})
          body = {
            organization: @organization,
            name: name
          }

          body.merge!(options)

          create('/security_groups', body)
        end
      end
    end
  end
end
