require 'securerandom'
require 'unit_test_helper'

class TestSecurityGroupRules < Minitest::Test
  def setup
    service = Fog::Scaleway::Compute.new

    security_groups = Fog::Scaleway::Compute::SecurityGroups.new(service: service)
    security_group = security_groups.create(
      name: "fog-test-units-#{self.class}-#{name}"
    )

    @security_group_rules = Fog::Scaleway::Compute::SecurityGroupRules.new(
      service: service,
      security_group: security_group
    )
  end

  def teardown
    Fog::Scaleway::Compute::Mock.reset if Fog.mocking?
  end

  def test_create_security_group_rule
    security_group_rule = @security_group_rules.create(
      action: 'drop',
      direction: 'inbound',
      ip_range: '0.0.0.0/0',
      protocol: 'TCP'
    )

    assert security_group_rule.persisted?
  end

  def test_create_security_group_rule_with_insufficent_parameters
    assert_raises ArgumentError do
      @security_group_rules.create
    end
  end

  def test_get_security_group_rule
    security_group_rule = @security_group_rules.create(
      action: 'drop',
      direction: 'inbound',
      ip_range: '0.0.0.0/0',
      protocol: 'TCP'
    )

    security_group_rule = @security_group_rules.get(security_group_rule.identity)

    assert security_group_rule.persisted?
  end

  def test_get_non_existent_security_group_rule
    assert_nil @security_group_rules.get(Fog::UUID.uuid)
  end

  def test_get_all_security_group_rules
    security_group_rule1 = @security_group_rules.create(
      action: 'drop',
      direction: 'inbound',
      ip_range: '0.0.0.0/0',
      protocol: 'TCP'
    )
    security_group_rule2 = @security_group_rules.create(
      action: 'drop',
      direction: 'inbound',
      ip_range: '0.0.0.0/0',
      protocol: 'TCP'
    )

    assert_includes @security_group_rules.all, security_group_rule1
    assert_includes @security_group_rules.all, security_group_rule2
  end

  def test_destroy_security_group_rule
    security_group_rule = @security_group_rules.create(
      action: 'drop',
      direction: 'inbound',
      ip_range: '0.0.0.0/0',
      protocol: 'TCP'
    )

    @security_group_rules.destroy(security_group_rule.identity)

    assert_nil @security_group_rules.get(security_group_rule.identity)
  end

  def test_destroy_non_existent_security_group_rule
    assert_raises Fog::Scaleway::Compute::UnknownResource do
      @security_group_rules.destroy(Fog::UUID.uuid)
    end
  end
end
