require 'fog/compute/models/server'

module Fog
  module Scaleway
    class Compute
      class Server < Fog::Compute::Server
        identity :id

        attribute :arch
        attribute :bootscript
        attribute :commercial_type
        attribute :creation_date
        attribute :dynamic_ip_required
        attribute :enable_ipv6
        attribute :extra_networks
        attribute :hostname
        attribute :image
        attribute :ipv6
        attribute :location
        attribute :modification_date
        attribute :name
        attribute :organization
        attribute :private_ip
        attribute :public_ip
        attribute :security_group
        attribute :state
        attribute :state_detail
        attribute :tags
        attribute :volumes, default: {}

        def bootscript=(value)
          attributes[:bootscript] = case value
                                    when Hash
                                      service.bootscripts.new(value)
                                    when String
                                      service.bootscripts.new(identity: value)
                                    else
                                      value
                                    end
        end

        def image=(value)
          attributes[:image] = case value
                               when Hash
                                 service.images.new(value)
                               when String
                                 service.images.new(identity: value)
                               else
                                 value
                               end
        end

        def public_ip=(value)
          attributes[:public_ip] = case value
                                   when Hash
                                     service.ips.new(value)
                                   when String
                                     service.ips.new(identity: value)
                                   else
                                     value
                                   end
        end

        def security_group=(value)
          attributes[:security_group] = case value
                                        when Hash
                                          service.security_groups.new(value)
                                        when String
                                          service.security_groups.new(identity: value)
                                        else
                                          value
                                        end
        end

        def volumes=(value)
          attributes[:volumes] = Hash[value.map { |i, v| [i, to_volume(v)] }]
        end

        def public_dns_name
          "#{identity}.pub.cloud.scaleway.com"
        end

        def private_dns_name
          "#{identity}.priv.cloud.scaleway.com"
        end

        def ready?
          state == 'running'
        end

        def save
          if persisted?
            update
          else
            create
          end
        end

        def destroy
          requires :identity

          service.delete_server(identity)
          true
        end

        def poweron(async = true)
          requires :identity

          execute_action('poweron', async)
        end

        def poweroff(async = true)
          requires :identity

          execute_action('poweroff', async)
        end

        def reboot(async = true)
          requires :identity

          execute_action('reboot', async)
        end

        def terminate(async = true)
          requires :identity

          execute_action('terminate', async)
        end

        def execute_action(action, async = true)
          requires :identity

          if (task = service.execute_server_action(identity, action).body['task'])
            service.tasks.new(task).tap do |t|
              unless async
                t.wait_for { t.success? }
                reload
              end
            end
          end
        end

        def attach_volume(volume)
          volumes[next_volume_index] = to_volume(volume)

          save if persisted?
        end

        def detach_volume(volume)
          volumes.reject! { |_k, v| v == to_volume(volume) }

          save if persisted?
        end

        def public_ip_address
          public_ip.address if public_ip
        end

        def private_ip_address
          private_ip
        end

        private

        def create
          requires :name, :image, :volumes

          options = {}
          options[:bootscript] = bootscript.identity unless bootscript.nil?
          options[:commercial_type] = commercial_type unless commercial_type.nil?
          options[:enable_ipv6] = enable_ipv6 unless enable_ipv6.nil?
          options[:dynamic_ip_required] = dynamic_ip_required unless dynamic_ip_required.nil?
          options[:public_ip] = public_ip.identity unless public_ip.nil?
          options[:security_group] = security_group.identity unless security_group.nil?
          options[:tags] = tags unless tags.nil?

          if (server = service.create_server(name, image.identity, volumes, options).body['server'])
            merge_attributes(server)
            true
          else
            false
          end
        end

        def update
          requires :identity

          body = attributes.dup

          unless public_ip.nil?
            body[:public_ip] = {
              id: public_ip.identity,
              address: public_ip.address
            }
          end

          unless security_group.nil?
            body[:security_group] = {
              id: security_group.identity,
              name: security_group.name
            }
          end

          if (server = service.update_server(identity, body).body['server'])
            merge_attributes(server)
            true
          else
            false
          end
        end

        def to_volume(value)
          case value
          when Hash
            service.volumes.new(value)
          when String
            service.volumes.new(identity: value)
          else
            value
          end
        end

        def next_volume_index
          used = volumes.keys.map(&:to_i)
          (1..Float::INFINITY).find { |i| !used.include?(i) }.to_s
        end
      end
    end
  end
end
