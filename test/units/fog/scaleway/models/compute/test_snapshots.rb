require 'securerandom'
require 'unit_test_helper'

class TestSnapshots < Minitest::Test
  def setup
    service = Fog::Scaleway::Compute.new

    volumes = Fog::Scaleway::Compute::Volumes.new(service: service)
    @volume = volumes.create(
      name: "fog-test-units-#{self.class}-#{name}",
      volume_type: 'l_ssd',
      size: 50_000_000_000
    )

    @snapshots = Fog::Scaleway::Compute::Snapshots.new(service: service)
  end

  def teardown
    Fog::Scaleway::Compute::Mock.reset if Fog.mocking?
  end

  def test_create_snapshot
    snapshot = @snapshots.create(
      name: "fog-test-units-#{self.class}-#{name}",
      base_volume: @volume.identity
    )

    assert snapshot.persisted?
  end

  def test_create_snapshot_with_insufficent_parameters
    assert_raises ArgumentError do
      @snapshots.create
    end
  end

  def test_get_snapshot
    snapshot = @snapshots.create(
      name: "fog-test-units-#{self.class}-#{name}",
      base_volume: @volume.identity
    )

    snapshot = @snapshots.get(snapshot.identity)

    assert snapshot.persisted?
  end

  def test_get_non_existent_snapshot
    assert_nil @snapshots.get(Fog::UUID.uuid)
  end

  def test_get_all_snapshots
    snapshot1 = @snapshots.create(
      name: "fog-test-units-#{self.class}-#{name}-1",
      base_volume: @volume.identity
    )
    snapshot2 = @snapshots.create(
      name: "fog-test-units-#{self.class}-#{name}-2",
      base_volume: @volume.identity
    )

    assert_includes @snapshots, snapshot1
    assert_includes @snapshots, snapshot2
  end

  def test_destroy_snapshot
    snapshot = @snapshots.create(
      name: "fog-test-units-#{self.class}-#{name}",
      base_volume: @volume.identity
    )

    @snapshots.destroy(snapshot.identity)

    assert_nil @snapshots.get(snapshot.identity)
  end

  def test_destroy_non_existent_snapshot
    assert_raises Fog::Scaleway::Compute::UnknownResource do
      @snapshots.destroy(Fog::UUID.uuid)
    end
  end
end
