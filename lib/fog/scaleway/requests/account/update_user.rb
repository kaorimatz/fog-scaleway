module Fog
  module Scaleway
    class Account
      class Real
        def update_user(user_id, options = {})
          request(method: :patch,
                  path: "/users/#{user_id}",
                  body: options,
                  expects: [200])
        end
      end

      class Mock
        def update_user(user_id, options = {})
          options = jsonify(options)

          user = lookup(:users, user_id)

          %w[firstname lastname].each do |attr|
            user[attr] = options[attr] if options.key?(attr)
          end

          user['fullname'] = [user['firstname'], user['lastname']].compact.join(' ')

          if (ssh_public_keys = options['ssh_public_keys'])
            user['ssh_public_keys'] = ssh_public_keys.map do |key|
              {
                'key' => key['key'],
                'fingerprint' => generate_fingerprint(key['key'])
              }
            end
          end

          response(status: 200, body: { 'user' => user })
        end
      end
    end
  end
end
