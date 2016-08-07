module Fog
  module Scaleway
    class Compute
      class Snapshots < Fog::Collection
        model Fog::Scaleway::Compute::Snapshot

        def all
          snapshots = service.list_snapshots.body['snapshots'] || []
          load(snapshots)
        end

        def get(identity)
          if (snapshot = service.get_snapshot(identity).body['snapshot'])
            new(snapshot)
          end
        rescue Fog::Scaleway::Compute::UnknownResource
          nil
        end
      end
    end
  end
end
