require 'fog/scaleway/client'
require 'fog/scaleway/errors'
require 'fog/scaleway/request_helper'

module Fog
  module Scaleway
    class Account < Fog::Service
      class InvalidRequestError < Error; end
      class InvalidAuth < Error; end
      class UnknownResource < Error; end
      class AuthorizationRequired < Error; end
      class APIError < Error; end

      requires   :scaleway_token
      recognizes :scaleway_email
      secrets    :scaleway_token

      model_path 'fog/scaleway/models/account'

      model      :token
      collection :tokens
      model      :organization
      collection :organizations
      model      :user
      collection :users

      request_path 'fog/scaleway/requests/account'

      # Tokens
      request :create_token
      request :list_tokens
      request :get_token
      request :update_token
      request :delete_token
      request :get_token_permissions

      # Organizations
      request :list_organizations
      request :get_organization
      request :get_organization_quotas

      # Users
      request :get_user
      request :update_user

      class Real
        include Fog::Scaleway::RequestHelper

        def initialize(options)
          @token = options[:scaleway_token]
          @email = options[:scaleway_email]
        end

        def request(params)
          client.request(params)
        rescue Excon::Errors::HTTPStatusError => error
          decoded = Fog::Scaleway::Errors.decode_error(error)
          raise if decoded.nil?

          type    = decoded[:type]
          message = decoded[:message]

          raise case type
                when 'invalid_request_error', 'invalid_auth', 'unknown_resource', 'authorization_required'
                  Fog::Scaleway::Account.const_get(camelize(type)).slurp(error, message)
                when 'api_error'
                  Fog::Scaleway::Account::APIError.slurp(error, message)
                else
                  Fog::Scaleway::Account::Error.slurp(error, message)
                end
        end

        private

        def client
          @client ||= Fog::Scaleway::Client.new('https://account.scaleway.com', @token)
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
