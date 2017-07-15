module Fog
  module Scaleway
    class Compute
      class ProductServers < Fog::Collection
        model Fog::Scaleway::Compute::ProductServer

        def all
          product_servers = service.list_product_servers.body['servers'] || {}
          product_servers = product_servers.map do |name, product_server|
            product_server.merge(name: name)
          end
          load(product_servers)
        end

        def get(name)
          product_servers = service.list_product_servers.body['servers'] || {}
          name, product_server = product_servers.find do |n, s|
            n == name || s['alt_names'].include?(name)
          end
          new(product_server.merge(name: name)) if product_server
        end
      end
    end
  end
end
