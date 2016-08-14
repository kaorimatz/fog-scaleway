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

      requires :scaleway_token
      requires :scaleway_organization
      secrets  :scaleway_token

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

      # Containers
      request :list_containers
      request :get_container

      # Dashboard
      request :get_dashboard

      class Real
        include Fog::Scaleway::RequestHelper

        def initialize(options)
          @token        = options[:scaleway_token]
          @organization = options[:scaleway_organization]
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
          @client ||= Fog::Scaleway::Client.new('https://api.scaleway.com', @token)
        end

        def camelize(str)
          str.split('_').collect(&:capitalize).join
        end
      end

      class Mock
      end
    end
  end
end
