require 'integration_test_helper'

class TestSnapshots < Minitest::Test
  def setup
    @images = Fog::Scaleway[:compute].images
    @servers = Fog::Scaleway[:compute].servers
    @volumes = Fog::Scaleway[:compute].volumes
    @snapshots = Fog::Scaleway[:compute].snapshots
  end

  def test_create_update_destroy
    server = @servers.create(
      name: "fog-test-integration-#{self.class}-#{name}",
      image: X86_64_IMAGE_ID
    )

    snapshot = @snapshots.create(
      name: "fog-test-integration-#{self.class}-#{name}",
      base_volume: server.volumes.values.first
    )

    assert_includes @snapshots.all, snapshot

    assert_equal snapshot, @snapshots.get(snapshot.identity)

    snapshot.name = "fog-test-integration-#{self.class}-#{name}-updated"
    snapshot.save

    snapshot = @snapshots.get(snapshot.identity)

    assert_equal "fog-test-integration-#{self.class}-#{name}-updated", snapshot.name

    snapshot.destroy

    Fog.wait_for { !@snapshots.all.include?(snapshot) }

    assert_nil @snapshots.get(snapshot.identity)

    server.destroy
    server.volumes.values.each(&:destroy)

    Fog.wait_for { !@servers.all.include?(server) }
    server.volumes.values.each { |v| Fog.wait_for { !@volumes.all.include?(v) } }
  end

  def test_create_image
    server = @servers.create(
      name: "fog-test-integration-#{self.class}-#{name}",
      image: X86_64_IMAGE_ID
    )

    snapshot = @snapshots.create(
      name: "fog-test-integration-#{self.class}-#{name}",
      base_volume: server.volumes.values.first
    )

    image = snapshot.create_image("fog-test-integration-#{self.class}-#{name}", 'x86_64')

    assert_equal snapshot, image.root_volume

    image.destroy
    snapshot.destroy
    server.destroy
    server.volumes.values.each(&:destroy)

    Fog.wait_for { !@images.all.include?(image) }
    Fog.wait_for { !@snapshots.all.include?(snapshot) }
    Fog.wait_for { !@servers.all.include?(server) }
    server.volumes.values.each { |v| Fog.wait_for { !@volumes.all.include?(v) } }
  end

  def test_create_volume
    server = @servers.create(
      name: "fog-test-integration-#{self.class}-#{name}",
      image: X86_64_IMAGE_ID
    )

    snapshot = @snapshots.create(
      name: "fog-test-integration-#{self.class}-#{name}",
      base_volume: server.volumes.values.first
    )

    volume = snapshot.create_volume

    assert_equal snapshot.size, volume.size
    assert_equal snapshot.volume_type, volume.volume_type

    volume.destroy
    snapshot.destroy
    server.destroy
    server.volumes.values.each(&:destroy)

    Fog.wait_for { !@volumes.all.include?(volume) }
    Fog.wait_for { !@snapshots.all.include?(snapshot) }
    Fog.wait_for { !@servers.all.include?(server) }
    server.volumes.values.each { |v| Fog.wait_for { !@volumes.all.include?(v) } }
  end
end
