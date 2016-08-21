module Fog
  module Scaleway
    class Compute
      class Real
        def get_bootscript(bootscript_id)
          get("/bootscripts/#{bootscript_id}")
        end
      end

      class Mock
        def get_bootscript(bootscript_id)
          bootscript = lookup(:bootscripts, bootscript_id)

          response(status: 200, body: { 'bootscript' => bootscript })
        end
      end
    end
  end
end
