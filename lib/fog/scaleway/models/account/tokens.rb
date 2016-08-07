module Fog
  module Scaleway
    class Account
      class Tokens < Fog::Collection
        model Fog::Scaleway::Account::Token

        def all
          tokens = service.list_tokens.body['tokens'] || []
          load(tokens)
        end

        def get(identity)
          if (token = service.get_token(identity).body['token'])
            new(token)
          end
        rescue Fog::Scaleway::Account::UnknownResource
          nil
        end
      end
    end
  end
end
