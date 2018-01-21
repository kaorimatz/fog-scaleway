module Fog
  module Scaleway
    class Compute
      class ProductServer < Fog::Model
        identity :name

        attribute :alt_names
        attribute :arch
        attribute :baremetal
        attribute :hourly_price
        attribute :monthly_price
        attribute :ncpus
        attribute :network
        attribute :ram
        attribute :volumes_constraint
      end
    end
  end
end
