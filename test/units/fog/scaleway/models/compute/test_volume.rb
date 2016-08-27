require 'unit_test_helper'

class TestVolume < Minitest::Test
  def setup
    @service = Fog::Scaleway::Compute.new

    @servers = Fog::Scaleway::Compute::Servers.new(service: @service)
    @server = @servers.create(
      commercial_type: 'C2S',
      name: "fog-test-integration-#{self.class}-#{name}",
      image: '75c28f52-6c64-40fc-bb31-f53ca9d02de9'
    )

    @volumes = Fog::Scaleway::Compute::Volumes.new(service: @service)
    @volume = @volumes.new(
      name: "fog-test-units-#{self.class}-#{name}",
      volume_type: 'l_ssd',
      size: 50_000_000_000
    )
  end

  def teardown
    Fog::Scaleway::Compute::Mock.reset if Fog.mocking?
  end

  def test_save
    @volume.save

    assert @volume.persisted?

    @volume.name = "fog-test-units-#{self.class}-#{name}-updated"

    @volume.save

    assert_equal "fog-test-units-#{self.class}-#{name}-updated", @volume.name
  end

  def test_destroy
    @volume.save

    @volume.destroy

    assert_nil @volumes.get(@volume.identity)
  end

  def test_create_snapshot
    volume = @server.volumes.values.first

    snapshot = volume.create_snapshot

    assert_equal volume, snapshot.base_volume
  end

  def test_clone
    @volume.save

    new_volume = @volume.clone

    refute_equal @volume.identity, new_volume.identity
    assert_equal @volume.size, new_volume.size
    assert_equal @volume.volume_type, new_volume.volume_type
  end
end
