module Fog
  module Scaleway
    class Account
      class Token < Fog::Model
        identity :id

        attribute :creation_date
        attribute :creation_ip
        attribute :description
        attribute :expires
        attribute :inherits_user_perms
        attribute :roles
        attribute :user_id

        def save
          if persisted?
            update
          else
            create
          end
        end

        def destroy
          requires :identity

          service.delete_token(identity)
          true
        end

        private

        def create
          options = {}
          options[:description] = description unless description.nil?
          options[:expires] = expires != false unless expires.nil?

          if (token = service.create_token(options).body['token'])
            merge_attributes(token)
            true
          else
            false
          end
        end

        def update
          requires :identity

          options = {}
          options[:description] = description unless description.nil?
          options[:expires] = expires != false unless expires.nil?

          if (token = service.update_token(identity, options).body['token'])
            merge_attributes(token)
            true
          else
            false
          end
        end
      end
    end
  end
end
