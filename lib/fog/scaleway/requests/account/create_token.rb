module Fog
  module Scaleway
    class Account
      class Real
        def create_token(options = {})
          if @email.nil?
            raise ArgumentError, 'email is required to create a token'
          end

          body = {
            email: @email
          }

          body.merge!(options)

          create('/tokens', body)
        end
      end

      class Mock
        def create_token(options = {})
          if @email.nil?
            raise ArgumentError, 'email is required to create a token'
          end

          body = {
            email: @email
          }

          body.merge!(options)

          body = jsonify(body)

          user = data[:users].values.find do |u|
            u['email'] == body['email']
          end

          raise_invalid_auth('Invalid credentials') unless user

          expires = nil
          if body['expires'] != false
            expires = (Time.now + 30 * 60).utc.strftime(TIME_FORMAT)
          end

          token = {
            'user_id' => user['id'],
            'description' => body['description'] || '',
            'roles' => { 'organization' => nil, 'role' => nil },
            'expires' => expires,
            'creation_date' => now,
            'inherits_user_perms' => true,
            'id' => Fog::UUID.uuid
          }

          data[:tokens][token['id']] = token

          response(status: 201, body: { 'token' => token })
        end
      end
    end
  end
end
