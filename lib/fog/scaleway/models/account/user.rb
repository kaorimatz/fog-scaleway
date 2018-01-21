module Fog
  module Scaleway
    class Account
      class User < Fog::Model
        identity :id

        attribute :creation_date
        attribute :double_auth_enabled
        attribute :email
        attribute :firstname
        attribute :fullname
        attribute :lastname
        attribute :modification_date
        attribute :organizations
        attribute :phone_number
        attribute :roles
        attribute :ssh_public_keys

        def organizations=(value)
          attributes[:organizations] = value.map do |v|
            case v
            when Hash
              service.organizations.new(v)
            when String
              service.organizations.new(identity: v)
            else
              v
            end
          end
        end

        def save
          if persisted?
            update
          else
            create
          end
        end

        private

        def create
          raise Fog::Errors::NotImplemented
        end

        def update
          requires :identity

          options = {}
          options[:firstname] = firstname unless firstname.nil?
          options[:lastname] = lastname unless lastname.nil?

          unless ssh_public_keys.nil?
            options[:ssh_public_keys] = ssh_public_keys.map do |k|
              { 'key' => k['key'] }
            end
          end

          if (user = service.update_user(identity, options).body['user'])
            merge_attributes(user)
            true
          else
            false
          end
        end
      end
    end
  end
end
