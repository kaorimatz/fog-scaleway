module Fog
  module Scaleway
    class Compute
      class Volume < Fog::Model
        identity :id

        attribute :creation_date
        attribute :export_uri
        attribute :modification_date
        attribute :name
        attribute :organization
        attribute :server
        attribute :size
        attribute :volume_type

        def server=(value)
          attributes[:server] = case value
                                when Hash
                                  service.servers.new(value)
                                when String
                                  service.servers.new(identity: value)
                                else
                                  value
                                end
        end

        def save
          if persisted?
            update
          else
            create
          end
        end

        def destroy
          requires :identity

          service.delete_volume(identity)
          true
        end

        def create_snapshot(name = nil)
          requires :identity

          if name.nil?
            requires :name

            name = "#{self.name} snapshot"
          end

          if (snapshot = service.create_snapshot(name, identity).body['snapshot'])
            service.snapshots.new(snapshot)
          end
        end

        def clone(name = nil)
          requires :identity, :volume_type

          if name.nil?
            requires :name

            name = "#{self.name} - (Copy)"
          end

          if (volume = service.create_volume(name, volume_type, base_volume: identity).body['volume'])
            service.volumes.new(volume)
          end
        end

        private

        def create
          requires :name, :volume_type, :size

          if (volume = service.create_volume(name, volume_type, size: size).body['volume'])
            merge_attributes(volume)
            true
          else
            false
          end
        end

        def update
          requires :identity

          if (volume = service.update_volume(identity, self).body['volume'])
            merge_attributes(volume)
            true
          else
            false
          end
        end
      end
    end
  end
end
