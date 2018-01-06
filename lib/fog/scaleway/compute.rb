require 'fog/scaleway/client'
require 'fog/scaleway/errors'
require 'fog/scaleway/request_helper'

module Fog
  module Scaleway
    class Compute < Fog::Service
      class InvalidRequestError < Error; end
      class InvalidAuth < Error; end
      class AuthorizationRequired < Error; end
      class UnknownResource < Error; end
      class Conflict < Error; end
      class APIError < Error; end

      requires   :scaleway_token
      requires   :scaleway_organization
      recognizes :scaleway_region
      secrets    :scaleway_token

      model_path 'fog/scaleway/models/compute'

      model      :server
      collection :servers
      model      :volume
      collection :volumes
      model      :snapshot
      collection :snapshots
      model      :image
      collection :images
      model      :ip
      collection :ips
      model      :security_group
      collection :security_groups
      model      :security_group_rule
      collection :security_group_rules
      model      :bootscript
      collection :bootscripts
      model      :task
      collection :tasks
      model      :product_server
      collection :product_servers

      request_path 'fog/scaleway/requests/compute'

      # Servers
      request :create_server
      request :list_servers
      request :get_server
      request :update_server
      request :delete_server
      request :list_server_actions
      request :execute_server_action
      request :list_user_data
      request :get_user_data
      request :update_user_data
      request :delete_user_data

      # Volumes
      request :create_volume
      request :list_volumes
      request :get_volume
      request :update_volume
      request :delete_volume

      # Snapshots
      request :create_snapshot
      request :list_snapshots
      request :get_snapshot
      request :update_snapshot
      request :delete_snapshot

      # Images
      request :create_image
      request :list_images
      request :get_image
      request :update_image
      request :delete_image

      # IPs
      request :create_ip
      request :list_ips
      request :get_ip
      request :update_ip
      request :delete_ip

      # Security Groups
      request :create_security_group
      request :list_security_groups
      request :get_security_group
      request :update_security_group
      request :delete_security_group
      request :create_security_group_rule
      request :list_security_group_rules
      request :get_security_group_rule
      request :update_security_group_rule
      request :delete_security_group_rule

      # Bootscripts
      request :list_bootscripts
      request :get_bootscript

      # Tasks
      request :list_tasks
      request :get_task
      request :delete_task

      # Containers
      request :list_containers
      request :get_container

      # Products
      request :list_product_servers

      # Dashboard
      request :get_dashboard

      class Real
        include Fog::Scaleway::RequestHelper

        def initialize(options)
          @token              = options[:scaleway_token]
          @organization       = options[:scaleway_organization]
          @region             = options[:scaleway_region] || 'par1'
          @connection_options = options[:connection_options] || {}
        end

        def request(params)
          client.request(params)
        rescue Excon::Errors::HTTPStatusError => error
          decoded = Fog::Scaleway::Errors.decode_error(error)
          raise if decoded.nil?

          type    = decoded[:type]
          message = decoded[:message]

          raise case type
                when 'invalid_request_error', 'invalid_auth', 'authorization_required', 'unknown_resource', 'conflict'
                  Fog::Scaleway::Compute.const_get(camelize(type)).slurp(error, message)
                when 'api_error'
                  Fog::Scaleway::Compute::APIError.slurp(error, message)
                else
                  Fog::Scaleway::Compute::Error.slurp(error, message)
                end
        end

        private

        def client
          @client ||= Fog::Scaleway::Client.new(endpoint, @token, @connection_options)
        end

        def endpoint
          "https://cp-#{@region}.scaleway.com"
        end

        def camelize(str)
          str.split('_').collect(&:capitalize).join
        end
      end

      class Mock
        INITIAL_IMAGES = [{
          'default_bootscript' => {
            'kernel' => 'http://169.254.42.24/kernel/x86_64-4.5.7-std-3/vmlinuz-4.5.7-std-3',
            'initrd' => 'http://169.254.42.24/initrd/initrd-Linux-x86_64-v3.11.1.gz',
            'default' => true,
            'bootcmdargs' => 'LINUX_COMMON ip=:::::eth0: boot=local',
            'architecture' => 'x86_64',
            'title' => 'x86_64 4.5.7 std #3 (latest/stable)',
            'dtb' => '',
            'organization' => '11111111-1111-4111-8111-111111111111',
            'id' => '3b522e7a-8468-4577-ab3e-2b9535384bb8',
            'public' => true
          },
          'creation_date' => '2016-05-20T09:35:48.735687+00:00',
          'name' => 'Ubuntu Xenial (16.04 latest)',
          'modification_date' => '2016-07-12T15:19:54.680577+00:00',
          'organization' => 'abaeb1aa-760b-4391-aeab-c0622be90abf',
          'extra_volumes' => '[]',
          'arch' => 'x86_64',
          'id' => '75c28f52-6c64-40fc-bb31-f53ca9d02de9',
          'root_volume' => {
            'size' => 50_000_000_000,
            'id' => '714abe6f-5721-4222-ae69-15b4a6488f22',
            'volume_type' => 'l_ssd',
            'name' => 'x86_64-ubuntu-xenial-2016-05-20_09:25'
          },
          'public' => true
        }, {
          'default_bootscript' => {
            'kernel' => 'kernel/armv7l-4.5.7-std-4',
            'initrd' => 'initrd/uInitrd-Linux-armv7l-v3.11.1',
            'default' => true,
            'bootcmdargs' => 'LINUX_COMMON ip=:::::eth0: boot=local',
            'architecture' => 'arm',
            'title' => 'armv7l 4.5.7 std #4 (latest)',
            'dtb' => 'dtb/c1-armv7l-4.5.7-std-4',
            'organization' => '11111111-1111-4111-8111-111111111111',
            'id' => '599b736c-48b5-4530-9764-f04d06ecadc7',
            'public' => true
          },
          'creation_date' => '2016-05-20T09:00:08.222054+00:00',
          'name' => 'Ubuntu Xenial (16.04 latest)',
          'modification_date' => '2016-07-12T15:21:13.269384+00:00',
          'organization' => 'abaeb1aa-760b-4391-aeab-c0622be90abf',
          'extra_volumes' => '[]',
          'arch' => 'arm',
          'id' => 'eeb73cbf-78a9-4481-9e38-9aaadaf8e0c9',
          'root_volume' => {
            'size' => 50_000_000_000,
            'id' => 'ea3aaf5a-c91b-463d-9093-00fae8632cfd',
            'volume_type' => 'l_ssd',
            'name' => 'armv7l-ubuntu-xenial-2016-05-20_08:51'
          },
          'public' => true
        }].freeze

        PRODUCTS = {
          'servers' => {
            'VC1S' => {
              'volumes_constraint' => {
                'min_size' => nil,
                'max_size' => 50_000_000_000
              },
              'network' => {
                'interfaces' => [{
                  'internal_bandwidth' => nil,
                  'internet_bandwidth' => 209_715_200
                }],
                'sum_internal_bandwidth' => nil,
                'sum_internet_bandwidth' => 209_715_200,
                'ipv6_support' => true
              },
              'ncpus' => 2,
              'ram' => 2_147_483_648,
              'alt_names' => ['X64-2GB'],
              'baremetal' => false,
              'arch' => 'x86_64'
            },
            'C1' => {
              'volumes_constraint' => nil,
              'network' => {
                'interfaces' => [{
                  'internal_bandwidth' => 1_073_741_824,
                  'internet_bandwidth' => 209_715_200
                }],
                'sum_internal_bandwidth' => 1_073_741_824,
                'sum_internet_bandwidth' => 209_715_200,
                'ipv6_support' => false
              },
              'ncpus' => 4,
              'ram' => 2_147_483_648,
              'alt_names' => [],
              'baremetal' => true,
              'arch' => 'arm'
            }
          }
        }.freeze

        def self.data
          @data ||= Hash.new do |hash, token|
            hash[token] = {
              servers: {},
              user_data: Hash.new({}),
              volumes: {},
              snapshots: {},
              images: Hash[INITIAL_IMAGES.map { |i| [i['id'], i] }],
              ips: {},
              security_groups: {},
              security_group_rules: Hash.new({}),
              bootscripts: Hash[INITIAL_IMAGES.map do |i|
                [i['default_bootscript']['id'], i['default_bootscript']]
              end],
              tasks: {},
              containers: {},
              server_actions: Hash.new(%w[poweron poweroff reboot terminate])
            }
          end
        end

        def initialize(options)
          @token = options[:scaleway_token]
        end

        def self.reset
          @data = nil
        end

        private

        def data
          self.class.data[@token]
        end

        def lookup(type, id)
          data[type][id] || raise_unknown_resource(id)
        end

        def lookup_product_server(name)
          PRODUCTS['servers'].find { |n, s| n == name || s['alt_names'].include?(name) }
        end

        def default_security_group
          data[:security_groups].values.find { |s| s['organization_default'] }
        end

        def create_default_security_group
          name = 'Default security group'
          options = {
            description: 'Auto generated security group.',
            organization_default: true
          }

          create_security_group(name, options).body['security_group']
        end

        def create_dynamic_ip
          {
            'dynamic' => true,
            'id' => Fog::UUID.uuid,
            'address' => Fog::Mock.random_ip
          }
        end

        def create_ipv6
          {
            'netmask' => '127',
            'gateway' => random_ipv6.mask(127).to_s,
            'address' => random_ipv6.mask(127).succ.to_s
          }
        end

        def terminate_server(server)
          data[:servers].delete(server['id'])

          security_group = lookup(:security_groups, server['security_group']['id'])
          security_group['servers'].reject! { |s| s['id'] == server['id'] }

          server['volumes'].each_value do |volume|
            volume['server'] = nil
            delete_volume(volume['id'])
          end
        end

        def response(params)
          params[:headers] ||= {}
          params[:headers]['Content-Type'] ||= 'application/json'

          params[:body] = encode_body(params)

          response = Excon::Response.new(params)

          response.body = decode_body(response)

          response
        end

        def encode_body(params)
          body         = params[:body]
          content_type = params[:headers]['Content-Type']

          if body.nil? || body.is_a?(String)
            body
          elsif content_type =~ %r{application/json.*}i
            Fog::JSON.encode(body)
          else
            body.to_s
          end
        end

        def decode_body(response)
          body         = response.body
          content_type = response.headers['Content-Type']

          if !body.nil? && !body.empty? && content_type =~ %r{application/json.*}i
            Fog::JSON.decode(body)
          else
            body
          end
        end

        def raise_invalid_request_error(message)
          raise Fog::Scaleway::Compute::InvalidRequestError, message
        end

        def raise_unknown_resource(id)
          raise Fog::Scaleway::Compute::UnknownResource, "\"#{id}\" not found"
        end

        def raise_conflict(message)
          raise Fog::Scaleway::Compute::Conflict, message
        end

        def now
          Time.now.utc.strftime('%Y-%m-%dT%H:%M:%S.%6N%:z')
        end

        def jsonify(value)
          Fog::JSON.decode(Fog::JSON.encode(value))
        end

        def random_ipv6
          IPAddr.new(1 + rand((2**128) - 1), Socket::AF_INET6)
        end
      end
    end
  end
end
