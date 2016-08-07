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
    end
  end
end
