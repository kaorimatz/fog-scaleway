module Fog
  module Scaleway
    class Compute
      class Real
        def list_security_group_rules(security_group_id)
          get("/security_groups/#{security_group_id}/rules")
        end
      end

      class Mock
        def list_security_group_rules(security_group_id)
          security_group = lookup(:security_groups, security_group_id)

          rules = data[:security_group_rules][security_group['id']].values

          response(status: 200, body: { 'rules' => rules })
        end
      end
    end
  end
end
