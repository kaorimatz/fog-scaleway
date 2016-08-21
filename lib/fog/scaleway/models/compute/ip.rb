module Fog
  module Scaleway
    class Compute
      class Ip < Fog::Model
        identity :id

        attribute :address
        attribute :organization
        attribute :reverse
        attribute :server

        ignore_attributes :dynamic

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

          service.delete_ip(identity)
          true
        end

        private

        def create
          options = {}
          options[:server] = server.identity unless server.nil?

          if (ip = service.create_ip(options).body['ip'])
            merge_attributes(ip)
            true
          else
            false
          end
        end

        def update
          requires :identity

          body = attributes.dup
          body[:server] = server.identity unless server.nil?

          if (ip = service.update_ip(identity, body).body['ip'])
            merge_attributes(ip)
            true
          else
            false
          end
        end
      end
    end
  end
end
