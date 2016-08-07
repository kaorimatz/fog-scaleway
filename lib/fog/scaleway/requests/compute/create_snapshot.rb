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
    end
  end
end
