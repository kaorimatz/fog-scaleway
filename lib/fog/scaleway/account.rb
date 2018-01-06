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
          @token              = options[:scaleway_token]
          @email              = options[:scaleway_email]
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
          @client ||= Fog::Scaleway::Client.new('https://account.scaleway.com', @token, @connection_options)
        end

        def camelize(str)
          str.split('_').collect(&:capitalize).join
        end
      end

      class Mock
        TIME_FORMAT = '%Y-%m-%dT%H:%M:%S.%6N%:z'.freeze

        ORGANIZATION = {
          'address_line2' => 'ADDRESS LINE2',
          'address_country_code' => 'ADDRESS COUNTRY CODE',
          'address_line1' => 'ADDRESS LINE1',
          'support_level' => 'SUPPORT LEVEL',
          'name' => 'ORGANIZATION',
          'modification_date' => Time.now.utc.strftime(TIME_FORMAT),
          'currency' => 'CURRENCY',
          'locale' => 'LOCALE',
          'customer_class' => 'CUSTOMER CLASS',
          'support_id' => 'SUPPORT ID',
          'creation_date' => Time.now.utc.strftime(TIME_FORMAT),
          'address_postal_code' => 'ADDRESS POSTAL CODE',
          'address_city_name' => 'ADDRESS CITY NAME',
          'address_subdivision_code' => 'ADDRESS SUBDIVISION CODE',
          'timezone' => 'TIMEZONE',
          'vat_number' => nil,
          'support_pin' => 'SUPPORT PIN',
          'id' => '7c91ef18-eea8-4f4f-bfca-deaea872338c',
          'warnings' => [],
          'users' => [{
            'phone_number' => nil,
            'firstname' => 'FIRSTNAME',
            'lastname' => 'LASTNAME',
            'creation_date' => Time.now.utc.strftime(TIME_FORMAT),
            'ssh_public_keys' => [],
            'id' => 'e9459194-0f66-4958-b3c3-01e623d21566',
            'organizations' => [{
              'id' => '7c91ef18-eea8-4f4f-bfca-deaea872338c',
              'name' => 'ORGANIZATION'
            }],
            'modification_date' => Time.now.utc.strftime(TIME_FORMAT),
            'roles' => [{
              'organization' => {
                'id' => '7c91ef18-eea8-4f4f-bfca-deaea872338c',
                'name' => 'ORGANIZATION'
              },
              'role' => 'ROLE'
            }],
            'fullname' => 'FULLNAME',
            'email' => 'scaleway@example.com'
          }]
        }.freeze

        ORGANIZATION_QUOTAS = {
          'sis' => 100,
          'servers_type_VC1M' => 25,
          'servers_type_VC1L' => 10,
          'servers_type_C1' => 2,
          'servers_type_C2M' => 5,
          'servers_type_C2L' => 4,
          'ips' => 10,
          'snapshots' => 25,
          'servers' => 10,
          'security_rules' => 30,
          'servers_type_C2S' => 10,
          'trusted' => 1,
          'volumes' => 20,
          'images' => 100,
          'servers_type_VC1S' => 50,
          'invites' => 100,
          'security_groups' => 100
        }.freeze

        TOKEN_PERMISSIONS = {
          'account' => {
            'token:*' => [ORGANIZATION['users'][0]['id']],
            'organization:*' => [ORGANIZATION['id']],
            'user:*' => [ORGANIZATION['users'][0]['id']]
          },
          'task' => { 'tasks:*' => ["#{ORGANIZATION['id']}:*"] },
          'compute' => {
            'security_groups:*' => ["#{ORGANIZATION['id']}:*"],
            'images:*' => ["#{ORGANIZATION['id']}:*"],
            'servers:*' => ["#{ORGANIZATION['id']}:*"],
            'ips:*' => ["#{ORGANIZATION['id']}:*"],
            'snapshots:*' => ["#{ORGANIZATION['id']}:*"],
            'volumes:*' => ["#{ORGANIZATION['id']}:*"]
          },
          'billing' => {
            'usages:*' => ["#{ORGANIZATION['id']}:*"],
            'invoices:*' => ["#{ORGANIZATION['id']}:*"]
          },
          'storage' => {
            'storage:*' => ["#{ORGANIZATION['id']}:*"]
          },
          'dns' => {
            'dns:*' => ["#{ORGANIZATION['id']}:*"]
          },
          'ticket' => {
            'tickets:*' => [ORGANIZATION['users'][0]['id']]
          },
          'payment' => {
            'cards:*' => ["#{ORGANIZATION['id']}:*"]
          }
        }.freeze

        def self.data
          @data ||= Hash.new do |hash, token|
            hash[token] = {
              organizations: { ORGANIZATION['id'] => ORGANIZATION },
              organization_quotas: Hash.new(ORGANIZATION_QUOTAS),
              tokens: {},
              token_permissions: Hash.new(TOKEN_PERMISSIONS),
              users: { ORGANIZATION['users'][0]['id'] => ORGANIZATION['users'][0] }
            }
          end
        end

        def initialize(options)
          @token = options[:scaleway_token]
          @email = options[:scaleway_email]
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
          raise Fog::Scaleway::Account::InvalidRequestError, message
        end

        def raise_invalid_auth(message)
          raise Fog::Scaleway::Account::InvalidAuth, message
        end

        def raise_unknown_resource(id)
          raise Fog::Scaleway::Account::UnknownResource, "\"#{id}\" not found"
        end

        def now
          Time.now.utc.strftime(TIME_FORMAT)
        end

        def jsonify(value)
          Fog::JSON.decode(Fog::JSON.encode(value))
        end

        def generate_fingerprint(ssh_public_key)
          require 'base64'
          require 'digest/md5'

          type, key, comment = ssh_public_key.split(' ', 3)

          unless type == 'ssh-rsa'
            raise ArgumentError, "Unsupported public key format: #{type}"
          end

          size = decode_public_key(Base64.decode64(key)).last.num_bytes * 8

          fingerprint = Digest::MD5.hexdigest(Base64.decode64(key)).scan(/../).join(':')

          "#{size} #{fingerprint} #{comment} (RSA)"
        end

        def decode_public_key(key)
          type, *nums = unpack_public_key(key)
          [type] + nums.map { |n| OpenSSL::BN.new(n, 2) }
        end

        def unpack_public_key(key)
          vs = []
          until key.empty?
            n, key = key.unpack('Na*')
            v, key = key.unpack("a#{n}a*")
            vs << v
          end
          vs
        end
      end
    end
  end
end
