module Fog
  module Scaleway
    class Account
      class Organizations < Fog::Collection
        model Fog::Scaleway::Account::Organization

        def all
          organizations = service.list_organizations.body['organizations'] || []
          load(organizations)
        end

        def get(identity)
          if (organization = service.get_organization(identity).body['organization'])
            new(organization)
          end
        rescue Fog::Scaleway::Account::UnknownResource
          nil
        end
      end
    end
  end
end
