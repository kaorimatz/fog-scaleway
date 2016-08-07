module Fog
  module Scaleway
    class Account
      class Organization < Fog::Model
        identity :id

        attribute :address_city_name
        attribute :address_country_code
        attribute :address_line1
        attribute :address_line2
        attribute :address_postal_code
        attribute :address_subdivision_code
        attribute :creation_date
        attribute :currency
        attribute :customer_class
        attribute :locale
        attribute :modification_date
        attribute :name
        attribute :support_id
        attribute :support_level
        attribute :support_pin
        attribute :timezone
        attribute :users
        attribute :vat_number
        attribute :warnings

        def users=(value)
          attributes[:users] = value.map do |v|
            case v
            when Hash
              service.users.new(v)
            when String
              service.users.new(identity: v)
            else
              v
            end
          end
        end
      end
    end
  end
end
