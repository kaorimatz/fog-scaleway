require 'integration_test_helper'

class TestVolumes < Minitest::Test
  def setup
    @servers = Fog::Scaleway[:compute].servers
    @volumes = Fog::Scaleway[:compute].volumes
    @snapshots = Fog::Scaleway[:compute].snapshots
  end

  def test_create_update_destroy
    volume = @volumes.create(
      name: "fog-test-integration-#{self.class}-#{name}",
      size: 50_000_000_000,
      volume_type: 'l_ssd'
    )

    assert_includes @volumes.all, volume

    assert_equal volume, @volumes.get(volume.identity)

    volume.name = "fog-test-integration-#{self.class}-#{name}-updated"
    volume.save

    volume = @volumes.get(volume.identity)

    assert_equal "fog-test-integration-#{self.class}-#{name}-updated", volume.name

    volume.destroy

    Fog.wait_for { !@volumes.all.include?(volume) }

    assert_nil @volumes.get(volume.identity)
  end

  def test_create_snapshot
    server = @servers.create(
      name: "fog-test-integration-#{self.class}-#{name}",
      image: X86_64_IMAGE_ID
    )

    volume = server.volumes.values.first

    snapshot = volume.create_snapshot

    assert_equal volume, snapshot.base_volume

    snapshot.destroy
    server.destroy
    server.volumes.values.each(&:destroy)

    Fog.wait_for { !@snapshots.all.include?(snapshot) }
    Fog.wait_for { !@servers.all.include?(server) }
    server.volumes.values.each { |v| Fog.wait_for { !@volumes.all.include?(v) } }
  end

  def test_clone
    volume = @volumes.create(
      name: "fog-test-integration-#{self.class}-#{name}",
      size: 50_000_000_000,
      volume_type: 'l_ssd'
    )

    new_volume = volume.clone

    refute_equal volume.identity, new_volume.identity
    assert_equal volume.size, new_volume.size
    assert_equal volume.volume_type, new_volume.volume_type

    new_volume.destroy
    volume.destroy

    Fog.wait_for { !@volumes.all.include?(new_volume) }
    Fog.wait_for { !@volumes.all.include?(volume) }
  end
end
