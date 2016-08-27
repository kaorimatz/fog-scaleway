require 'unit_test_helper'

class TestIp < Minitest::Test
  def setup
    @service = Fog::Scaleway::Compute.new

    @ips = Fog::Scaleway::Compute::Ips.new(service: @service)
    @ip = @ips.new
  end

  def teardown
    Fog::Scaleway::Compute::Mock.reset if Fog.mocking?
  end

  def test_save
    @ip.save

    assert @ip.persisted?

    servers = Fog::Scaleway::Compute::Servers.new(service: @service)
    server = servers.create(
      commercial_type: 'C2S',
      name: "fog-test-integration-#{self.class}-#{name}",
      image: '75c28f52-6c64-40fc-bb31-f53ca9d02de9'
    )

    @ip.server = server

    @ip.save

    assert_equal server, @ip.server
  end

  def test_destroy
    @ip.save

    @ip.destroy

    assert_nil @ips.get(@ip.identity)
  end
end
