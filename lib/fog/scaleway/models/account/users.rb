module Fog
  module Scaleway
    class Account
      class Users < Fog::Collection
        model Fog::Scaleway::Account::User

        def all
          organizations = service.list_organizations.body['organizations'] || []
          users = organizations.flat_map { |o| o['users'] }
          load(users)
        end

        def get(identity)
          if (user = service.get_user(identity).body['user'])
            new(user)
          end
        rescue Fog::Scaleway::Account::UnknownResource
          nil
        end
      end
    end
  end
end
