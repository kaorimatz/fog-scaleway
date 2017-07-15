module Fog
  module Scaleway
    class Compute
      class ProductServer < Fog::Model
        identity :name

        attribute :volumes_constraint
        attribute :network
        attribute :ncpus
        attribute :ram
        attribute :alt_names
        attribute :baremetal
        attribute :arch
      end
    end
  end
end
