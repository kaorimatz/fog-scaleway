require 'securerandom'
require 'unit_test_helper'

class TestVolumes < Minitest::Test
  def setup
    service = Fog::Scaleway::Compute.new

    @volumes = Fog::Scaleway::Compute::Volumes.new(service: service)
  end

  def teardown
    Fog::Scaleway::Compute::Mock.reset if Fog.mocking?
  end

  def test_create_volume
    volume = @volumes.create(
      name: "fog-test-units-#{self.class}-#{name}",
      volume_type: 'l_ssd',
      size: 50_000_000_000
    )

    assert volume.persisted?
  end

  def test_create_volume_with_insufficent_parameters
    assert_raises ArgumentError do
      @volumes.create
    end
  end

  def test_get_volume
    volume = @volumes.create(
      name: "fog-test-units-#{self.class}-#{name}",
      volume_type: 'l_ssd',
      size: 50_000_000_000
    )

    volume = @volumes.get(volume.identity)

    assert volume.persisted?
  end

  def test_get_non_existent_volume
    assert_nil @volumes.get(Fog::UUID.uuid)
  end

  def test_get_all_volumes
    volume1 = @volumes.create(
      name: "fog-test-units-#{self.class}-#{name}-1",
      volume_type: 'l_ssd',
      size: 50_000_000_000
    )
    volume2 = @volumes.create(
      name: "fog-test-units-#{self.class}-#{name}-2",
      volume_type: 'l_ssd',
      size: 50_000_000_000
    )

    assert_includes @volumes.all, volume1
    assert_includes @volumes.all, volume2
  end

  def test_destroy_volume
    volume = @volumes.create(
      name: "fog-test-units-#{self.class}-#{name}",
      volume_type: 'l_ssd',
      size: 50_000_000_000
    )

    @volumes.destroy(volume.identity)

    assert_nil @volumes.get(volume.identity)
  end

  def test_destroy_non_existent_volume
    assert_raises Fog::Scaleway::Compute::UnknownResource do
      @volumes.destroy(Fog::UUID.uuid)
    end
  end
end
