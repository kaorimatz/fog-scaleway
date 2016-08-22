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
      image: '75c28f52-6c64-40fc-bb31-f53ca9d02de9'
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
      image: '75c28f52-6c64-40fc-bb31-f53ca9d02de9'
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
      image: '75c28f52-6c64-40fc-bb31-f53ca9d02de9'
    )
    server2 = @servers.create(
      name: "fog-test-units-#{self.class}-#{name}-2",
      image: '75c28f52-6c64-40fc-bb31-f53ca9d02de9'
    )

    assert_includes @servers.all, server1
    assert_includes @servers.all, server2
  end

  def test_destroy_server
    server = @servers.create(
      name: "fog-test-units-#{self.class}-#{name}",
      image: '75c28f52-6c64-40fc-bb31-f53ca9d02de9'
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
