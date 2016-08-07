module Fog
  module Scaleway
    class Compute
      class Snapshot < Fog::Model
        identity :id

        attribute :base_volume
        attribute :creation_date
        attribute :modification_date
        attribute :name
        attribute :organization
        attribute :size
        attribute :state
        attribute :volume_type

        def base_volume=(value)
          attributes[:base_volume] = case value
                                     when Hash
                                       service.volumes.new(value)
                                     when String
                                       service.volumes.new(identity: value)
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

          service.delete_snapshot(identity)
          true
        end

        def create_image(name, arch)
          requires :identity

          if (image = service.create_image(name, arch, identity).body['image'])
            service.images.new(image)
          end
        end

        def create_volume(name = nil)
          requires :identity, :volume_type

          if name.nil?
            requires :name

            name = "#{self.name} - (from snapshot)"
          end

          if (volume = service.create_volume(name, volume_type, base_snapshot: identity).body['volume'])
            service.volumes.new(volume)
          end
        end

        private

        def create
          requires :name, :base_volume

          if (snapshot = service.create_snapshot(name, base_volume.identity).body['snapshot'])
            merge_attributes(snapshot)
            true
          else
            false
          end
        end

        def update
          requires :identity

          if (snapshot = service.update_snapshot(identity, self).body['snapshot'])
            merge_attributes(snapshot)
            true
          else
            false
          end
        end
      end
    end
  end
end
