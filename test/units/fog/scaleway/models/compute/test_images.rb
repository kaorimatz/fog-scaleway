require 'securerandom'
require 'unit_test_helper'

class TestImages < Minitest::Test
  def setup
    service = Fog::Scaleway::Compute.new

    volumes = Fog::Scaleway::Compute::Volumes.new(service: service)
    @volume = volumes.create(
      name: "fog-test-units-#{self.class}-#{name}",
      volume_type: 'l_ssd',
      size: 50_000_000_000
    )

    snapshots = Fog::Scaleway::Compute::Snapshots.new(service: service)
    @snapshot = snapshots.create(
      name: "fog-test-units-#{self.class}-#{name}",
      base_volume: @volume.identity
    )

    @images = Fog::Scaleway::Compute::Images.new(service: service)
  end

  def teardown
    Fog::Scaleway::Compute::Mock.reset if Fog.mocking?
  end

  def test_create_image
    image = @images.create(
      name: "fog-test-units-#{self.class}-#{name}",
      arch: 'x86_64',
      root_volume: @snapshot.identity
    )

    assert image.persisted?
  end

  def test_create_image_with_insufficent_parameters
    assert_raises ArgumentError do
      @images.create
    end
  end

  def test_get_image
    image = @images.create(
      name: "fog-test-units-#{self.class}-#{name}",
      arch: 'x86_64',
      root_volume: @snapshot.identity
    )

    image = @images.get(image.identity)

    assert image.persisted?
  end

  def test_get_non_existent_image
    assert_nil @images.get(Fog::UUID.uuid)
  end

  def test_get_all_images
    image1 = @images.create(
      name: "fog-test-units-#{self.class}-#{name}-1",
      arch: 'x86_64',
      root_volume: @snapshot.identity
    )
    image2 = @images.create(
      name: "fog-test-units-#{self.class}-#{name}-2",
      arch: 'x86_64',
      root_volume: @snapshot.identity
    )

    assert_includes @images.all, image1
    assert_includes @images.all, image2
  end

  def test_destroy_image
    image = @images.create(
      name: "fog-test-units-#{self.class}-#{name}",
      arch: 'x86_64',
      root_volume: @snapshot.identity
    )

    @images.destroy(image.identity)

    assert_nil @images.get(image.identity)
  end

  def test_destroy_non_existent_image
    assert_raises Fog::Scaleway::Compute::UnknownResource do
      @images.destroy(Fog::UUID.uuid)
    end
  end
end
