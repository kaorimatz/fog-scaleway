require 'integration_test_helper'

class TestImages < Minitest::Test
  def setup
    @servers = Fog::Scaleway[:compute].servers
    @volumes = Fog::Scaleway[:compute].volumes
    @snapshots = Fog::Scaleway[:compute].snapshots
    @images = Fog::Scaleway[:compute].images
  end

  def test_create_update_destroy
    server = @servers.create(
      commercial_type: 'C2S',
      name: "fog-test-integration-#{self.class}-#{name}",
      image: '75c28f52-6c64-40fc-bb31-f53ca9d02de9'
    )

    snapshot = @snapshots.create(
      name: "fog-test-integration-#{self.class}-#{name}",
      base_volume: server.volumes.values.first
    )

    image = @images.create(
      name: "fog-test-integration-#{self.class}-#{name}",
      arch: 'x86_64',
      root_volume: snapshot
    )

    assert_includes @images.all, image

    assert_equal image, @images.get(image.identity)

    image.name = "fog-test-integration-#{self.class}-#{name}-updated"
    image.save

    image = @images.get(image.identity)

    assert_equal "fog-test-integration-#{self.class}-#{name}-updated", image.name

    image.destroy

    Fog.wait_for { !@images.all.include?(image) }

    assert_nil @images.get(image.identity)

    snapshot.destroy
    server.destroy
    server.volumes.values.each(&:destroy)

    Fog.wait_for { !@snapshots.all.include?(snapshot) }
    Fog.wait_for { !@servers.all.include?(server) }
    server.volumes.values.each { |v| Fog.wait_for { !@volumes.all.include?(v) } }
  end
end
