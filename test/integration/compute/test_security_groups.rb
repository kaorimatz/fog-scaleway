require 'test_helper'

class TestSecurityGroups < Minitest::Test
  def setup
    @security_groups = Fog::Scaleway[:compute].security_groups
  end

  def test_create_update_destroy
    security_group = @security_groups.create(
      name: "fog-test-integration-#{self.class}-#{name}"
    )

    assert_includes @security_groups.all, security_group

    assert_equal security_group, @security_groups.get(security_group.identity)

    security_group.name = "fog-test-integration-#{self.class}-#{name}-updated"
    security_group.description = "fog-test-integration-#{self.class}-#{name}-updated"
    security_group.enable_default_security = false
    security_group.save

    security_group = @security_groups.get(security_group.identity)

    assert_equal "fog-test-integration-#{self.class}-#{name}-updated", security_group.name
    assert_equal "fog-test-integration-#{self.class}-#{name}-updated", security_group.description
    assert_equal false, security_group.enable_default_security

    security_group.destroy

    Fog.wait_for { !@security_groups.all.include?(security_group) }

    assert_nil @security_groups.get(security_group.identity)
  end
end
