require 'integration_test_helper'

class TestSecurityGroupRules < Minitest::Test
  def setup
    @security_groups = Fog::Scaleway[:compute].security_groups
  end

  def test_create_destroy
    security_group = @security_groups.create(
      name: "fog-test-integration-#{self.class}-#{name}"
    )

    security_group_rules = security_group.rules

    security_group_rule = security_group_rules.create(
      action: 'drop',
      direction: 'inbound',
      ip_range: '0.0.0.0/0',
      protocol: 'TCP'
    )

    assert_includes security_group_rules.all, security_group_rule

    assert_equal security_group_rule, security_group_rules.get(security_group_rule.identity)

    security_group_rule.destroy

    Fog.wait_for { !security_group_rules.all.include?(security_group_rule) }

    assert_nil security_group_rules.get(security_group_rule.identity)

    security_group.destroy

    Fog.wait_for { !@security_groups.all.include?(security_group) }
  end
end
