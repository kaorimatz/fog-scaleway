module Fog
  module Scaleway
    class Compute
      class SecurityGroup < Fog::Model
        identity :id

        attribute :description, default: ''
        attribute :enable_default_security
        attribute :name
        attribute :organization
        attribute :organization_default
        attribute :servers

        def servers=(value)
          attributes[:servers] = value.map do |v|
            case v
            when Hash
              service.servers.new(v)
            when String
              service.servers.new(identity: v)
            else
              v
            end
          end
        end

        def rules
          service.security_group_rules(security_group: self)
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

          service.delete_security_group(identity)
          true
        end

        private

        def create
          requires :name, :description

          if (security_group = service.create_security_group(name, description).body['security_group'])
            merge_attributes(security_group)
            true
          else
            false
          end
        end

        def update
          requires :identity

          if (security_group = service.update_security_group(identity, self).body['security_group'])
            merge_attributes(security_group)
            true
          else
            false
          end
        end
      end
    end
  end
end
