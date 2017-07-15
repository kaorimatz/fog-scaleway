require 'securerandom'
require 'unit_test_helper'

class TestServers < Minitest::Test
  def setup
    service = Fog::Scaleway::Compute.new

    @servers = Fog::Scaleway::Compute::Servers.new(service: service)
  end

  def teardown
    Fog::Scaleway::Compute::Mock.reset if Fog.mocking?
  end

  def test_create_server
    server = @servers.create(
      name: "fog-test-units-#{self.class}-#{name}",
      image: X86_64_IMAGE_ID
    )

    assert server.persisted?
  end

  def test_create_server_with_insufficent_parameters
    assert_raises ArgumentError do
      @servers.create
    end
  end

  def test_get_server
    server = @servers.create(
      name: "fog-test-units-#{self.class}-#{name}",
      image: X86_64_IMAGE_ID
    )

    server = @servers.get(server.identity)

    assert server.persisted?
  end

  def test_get_non_existent_server
    assert_nil @servers.get(Fog::UUID.uuid)
  end

  def test_get_all_servers
    server1 = @servers.create(
      name: "fog-test-units-#{self.class}-#{name}-1",
      image: X86_64_IMAGE_ID
    )
    server2 = @servers.create(
      name: "fog-test-units-#{self.class}-#{name}-2",
      image: X86_64_IMAGE_ID
    )

    assert_includes @servers.all, server1
    assert_includes @servers.all, server2
  end

  def test_destroy_server
    server = @servers.create(
      name: "fog-test-units-#{self.class}-#{name}",
      image: X86_64_IMAGE_ID
    )

    @servers.destroy(server.identity)

    assert_nil @servers.get(server.identity)
  end

  def test_destroy_non_existent_server
    assert_raises Fog::Scaleway::Compute::UnknownResource do
      @servers.destroy(Fog::UUID.uuid)
    end
  end
end
