require 'unit_test_helper'

class TestImage < Minitest::Test
  def setup
    @service = Fog::Scaleway::Compute.new

    servers = Fog::Scaleway::Compute::Servers.new(service: @service)
    server = servers.create(
      commercial_type: 'C2S',
      name: "fog-test-integration-#{self.class}-#{name}",
      image: '75c28f52-6c64-40fc-bb31-f53ca9d02de9'
    )

    snapshots = Fog::Scaleway::Compute::Snapshots.new(service: @service)
    snapshot = snapshots.create(
      name: "fog-test-units-#{self.class}-#{name}",
      base_volume: server.volumes.values.first
    )

    @images = Fog::Scaleway::Compute::Images.new(service: @service)
    @image = @images.new(
      name: "fog-test-units-#{self.class}-#{name}",
      arch: 'x86_64',
      root_volume: snapshot
    )
  end

  def teardown
    Fog::Scaleway::Compute::Mock.reset if Fog.mocking?
  end

  def test_save
    @image.save

    assert @image.persisted?

    @image.default_bootscript = '599b736c-48b5-4530-9764-f04d06ecadc7'
    @image.name = "fog-test-units-#{self.class}-#{name}-updated"
    @image.arch = 'arm'

    @image.save

    assert_equal '599b736c-48b5-4530-9764-f04d06ecadc7', @image.default_bootscript.identity
    assert_equal "fog-test-units-#{self.class}-#{name}-updated", @image.name
    assert_equal 'arm', @image.arch
  end

  def test_destroy
    @image.save

    @image.destroy

    assert_nil @images.get(@image.identity)
  end
end
