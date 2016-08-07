module Fog
  module Scaleway
    class Compute
      class Real
        def get_bootscript(bootscript_id)
          get("/bootscripts/#{bootscript_id}")
        end
      end
    end
  end
end
