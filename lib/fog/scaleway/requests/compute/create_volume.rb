module Fog
  module Scaleway
    class Compute
      class Real
        def create_volume(name, volume_type, options)
          if options[:size].nil? && options[:base_volume].nil? && options[:base_snapshot].nil?
            raise ArgumentError, 'size, base_volume or base_snapshot are required to create a volume'
          end

          body = {
            organization: @organization,
            name: name,
            volume_type: volume_type
          }

          if !options[:size].nil?
            body[:size] = options[:size]
          elsif !options[:base_volume].nil?
            body[:base_volume] = options[:base_volume]
          else
            body[:base_snapshot] = options[:base_snapshot]
          end

          create('/volumes', body)
        end
      end
    end
  end
end
