require 'unit_test_helper'

class TestSecurityGroup < Minitest::Test
  def setup
    @service = Fog::Scaleway::Compute.new

    @security_groups = Fog::Scaleway::Compute::SecurityGroups.new(service: @service)
    @security_group = @security_groups.new(
      name: "fog-test-units-#{self.class}-#{name}"
    )
  end

  def teardown
    Fog::Scaleway::Compute::Mock.reset if Fog.mocking?
  end

  def test_save
    @security_group.save

    assert @security_group.persisted?

    @security_group.description = "fog-test-integration-#{self.class}-#{name}-updated"
    @security_group.enable_default_security = false
    @security_group.name = "fog-test-integration-#{self.class}-#{name}-updated"

    @security_group.save

    assert_equal "fog-test-integration-#{self.class}-#{name}-updated", @security_group.description
    assert_equal false, @security_group.enable_default_security
    assert_equal "fog-test-integration-#{self.class}-#{name}-updated", @security_group.name
  end

  def test_destroy
    @security_group.save

    @security_group.destroy

    assert_nil @security_groups.get(@security_group.identity)
  end
end
