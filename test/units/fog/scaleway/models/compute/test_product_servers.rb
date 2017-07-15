require 'securerandom'
require 'unit_test_helper'

class TestProductServers < Minitest::Test
  def setup
    service = Fog::Scaleway::Compute.new

    @product_servers = Fog::Scaleway::Compute::ProductServers.new(service: service)
  end

  def teardown
    Fog::Scaleway::Compute::Mock.reset if Fog.mocking?
  end

  def test_get_product_server
    product_server = @product_servers.get('X64-2GB')

    assert product_server.persisted?
  end

  def test_get_non_existent_product_server
    assert_nil @product_servers.get('NON_EXISTENT')
  end

  def test_get_all_product_servers
    product_server = @product_servers.get('X64-2GB')

    assert_includes @product_servers, product_server
  end
end
