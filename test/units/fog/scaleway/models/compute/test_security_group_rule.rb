require 'unit_test_helper'

class TestSecurityGroupRule < Minitest::Test
  def setup
    @service = Fog::Scaleway::Compute.new

    security_groups = Fog::Scaleway::Compute::SecurityGroups.new(service: @service)
    security_group = security_groups.create(
      name: "fog-test-units-#{self.class}-#{name}"
    )

    @security_group_rules = Fog::Scaleway::Compute::SecurityGroupRules.new(
      service: @service,
      security_group: security_group
    )
    @security_group_rule = @security_group_rules.new(
      action: 'drop',
      direction: 'inbound',
      ip_range: '0.0.0.0/0',
      protocol: 'TCP'
    )
  end

  def teardown
    Fog::Scaleway::Compute::Mock.reset if Fog.mocking?
  end

  def test_save
    @security_group_rule.save

    assert @security_group_rule.persisted?

    @security_group_rule.action = 'accept'
    @security_group_rule.dest_port_from = 80
    @security_group_rule.direction = 'outbound'
    @security_group_rule.ip_range = '10.0.0.0/8'
    @security_group_rule.protocol = 'UDP'

    @security_group_rule.save

    assert_equal 'accept', @security_group_rule.action
    assert_equal 80, @security_group_rule.dest_port_from
    assert_equal 'outbound', @security_group_rule.direction
    assert_equal '10.0.0.0/8', @security_group_rule.ip_range
    assert_equal 'UDP', @security_group_rule.protocol
  end

  def test_destroy
    @security_group_rule.save

    @security_group_rule.destroy

    assert_nil @security_group_rules.get(@security_group_rule.identity)
  end
end
