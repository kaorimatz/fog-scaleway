module Fog
  module Scaleway
    class Account
      class Real
        def update_token(token_id, options = {})
          request(method: :patch,
                  path: "/tokens/#{token_id}",
                  body: options,
                  expects: [200])
        end
      end

      class Mock
        def update_token(token_id, options = {})
          options = jsonify(options)

          token = lookup(:tokens, token_id)

          token['description'] = options['description'] unless options['description'].nil?
          token['expires'] = (Time.now + 30 * 60).utc.strftime(TIME_FORMAT)

          response(status: 200, body: { 'token' => token })
        end
      end
    end
  end
end
