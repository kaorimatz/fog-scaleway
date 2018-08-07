require 'fog/core'
require 'fog/json'
require 'fog/scaleway/version'

module Fog
  module Scaleway
    extend Fog::Provider

    autoload :Account, File.expand_path('scaleway/account', __dir__)
    autoload :Compute, File.expand_path('scaleway/compute', __dir__)

    service :account, 'Account'
    service :compute, 'Compute'
  end
end
