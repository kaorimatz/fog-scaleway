module Fog
  module Scaleway
    class Compute
      class Image < Fog::Model
        identity :id

        attribute :arch
        attribute :creation_date
        attribute :default_bootscript
        # attribute :extra_volumes
        attribute :modification_date
        attribute :name
        attribute :organization
        attribute :public
        attribute :root_volume

        def default_bootscript=(value)
          attributes[:default_bootscript] = case value
                                            when Hash
                                              service.bootscripts.new(value)
                                            when String
                                              service.bootscripts.new(identity: value)
                                            else
                                              value
                                            end
        end

        def root_volume=(value)
          attributes[:root_volume] = case value
                                     when Hash
                                       service.snapshots.new(value)
                                     when String
                                       service.snapshots.new(identity: value)
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

          service.delete_image(identity)
          true
        end

        private

        def create
          requires :name, :arch, :root_volume

          options = {}
          options[:default_bootscript] = default_bootscript.identity unless default_bootscript.nil?

          if (image = service.create_image(name, arch, root_volume.identity, options).body['image'])
            merge_attributes(image)
            true
          else
            false
          end
        end

        def update
          requires :identity

          if (image = service.update_image(identity, self).body['image'])
            merge_attributes(image)
            true
          else
            false
          end
        end
      end
    end
  end
end
