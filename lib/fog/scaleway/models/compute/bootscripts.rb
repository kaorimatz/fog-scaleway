module Fog
  module Scaleway
    class Compute
      class Bootscripts < Fog::Collection
        model Fog::Scaleway::Compute::Bootscript

        def all
          bootscripts = service.list_bootscripts.body['bootscripts'] || []
          load(bootscripts)
        end

        def get(identity)
          if (bootscript = service.get_bootscript(identity).body['bootscript'])
            new(bootscript)
          end
        rescue Fog::Scaleway::Compute::UnknownResource
          nil
        end
      end
    end
  end
end
