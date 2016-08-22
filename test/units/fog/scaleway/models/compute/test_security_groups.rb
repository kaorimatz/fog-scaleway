require 'securerandom'
require 'unit_test_helper'

class TestSecurityGroups < Minitest::Test
  def setup
    service = Fog::Scaleway::Compute.new

    @security_groups = Fog::Scaleway::Compute::SecurityGroups.new(service: service)
  end

  def teardown
    Fog::Scaleway::Compute::Mock.reset if Fog.mocking?
  end

  def test_create_security_group
    security_group = @security_groups.create(
      name: "fog-test-units-#{self.class}-#{name}"
    )

    assert security_group.persisted?
  end

  def test_create_security_group_with_insufficent_parameters
    assert_raises ArgumentError do
      @security_groups.create
    end
  end

  def test_get_security_group
    security_group = @security_groups.create(
      name: "fog-test-units-#{self.class}-#{name}"
    )

    security_group = @security_groups.get(security_group.identity)

    assert security_group.persisted?
  end

  def test_get_non_existent_security_group
    assert_nil @security_groups.get(Fog::UUID.uuid)
  end

  def test_get_all_security_groups
    security_group1 = @security_groups.create(
      name: "fog-test-units-#{self.class}-#{name}-1"
    )
    security_group2 = @security_groups.create(
      name: "fog-test-units-#{self.class}-#{name}-2"
    )

    assert_includes @security_groups.all, security_group1
    assert_includes @security_groups.all, security_group2
  end

  def test_destroy_security_group
    security_group = @security_groups.create(
      name: "fog-test-units-#{self.class}-#{name}"
    )

    @security_groups.destroy(security_group.identity)

    assert_nil @security_groups.get(security_group.identity)
  end

  def test_destroy_non_existent_security_group
    assert_raises Fog::Scaleway::Compute::UnknownResource do
      @security_groups.destroy(Fog::UUID.uuid)
    end
  end
end
