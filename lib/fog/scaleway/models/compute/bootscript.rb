module Fog
  module Scaleway
    class Compute
      class Bootscript < Fog::Model
        identity :id

        attribute :architecture
        attribute :bootcmdargs
        attribute :default
        attribute :dtb
        attribute :initrd
        attribute :kernel
        attribute :organization
        attribute :public
        attribute :title
      end
    end
  end
end
