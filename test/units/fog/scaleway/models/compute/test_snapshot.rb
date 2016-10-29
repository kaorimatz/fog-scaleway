require 'unit_test_helper'

class TestSnapshot < Minitest::Test
  def setup
    @service = Fog::Scaleway::Compute.new

    servers = Fog::Scaleway::Compute::Servers.new(service: @service)
    server = servers.create(
      commercial_type: 'C2S',
      name: "fog-test-integration-#{self.class}-#{name}",
      image: '75c28f52-6c64-40fc-bb31-f53ca9d02de9'
    )

    @snapshots = Fog::Scaleway::Compute::Snapshots.new(service: @service)
    @snapshot = @snapshots.new(
      name: "fog-test-units-#{self.class}-#{name}",
      base_volume: server.volumes.values.first
    )
  end

  def teardown
    Fog::Scaleway::Compute::Mock.reset if Fog.mocking?
  end

  def test_save
    @snapshot.save

    assert @snapshot.persisted?

    @snapshot.name = "fog-test-units-#{self.class}-#{name}-updated"

    @snapshot.save

    assert_equal "fog-test-units-#{self.class}-#{name}-updated", @snapshot.name
  end

  def test_destroy
    @snapshot.save

    @snapshot.destroy

    assert_nil @snapshots.get(@snapshot.identity)
  end

  def test_create_image
    @snapshot.save

    image = @snapshot.create_image("fog-test-units-#{self.class}-#{name}", 'x86_64')

    assert_equal @snapshot, image.root_volume
  end

  def test_create_volume
    @snapshot.save

    volume = @snapshot.create_volume

    assert_equal @snapshot.size, volume.size
    assert_equal @snapshot.volume_type, volume.volume_type
  end
end
