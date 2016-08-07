module Fog
  module Scaleway
    class Compute
      class Bootscript < Fog::Model
        identity :id

        attribute :kernel
        attribute :initrd
        attribute :default
        attribute :bootcmdargs
        attribute :architecture
        attribute :title
        attribute :dtb
        attribute :organization
        attribute :public
      end
    end
  end
end
