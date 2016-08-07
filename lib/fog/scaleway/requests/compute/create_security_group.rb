module Fog
  module Scaleway
    class Compute
      class Real
        def create_security_group(name, description)
          create('/security_groups', organization: @organization,
                                     name: name,
                                     description: description)
        end
      end
    end
  end
end
