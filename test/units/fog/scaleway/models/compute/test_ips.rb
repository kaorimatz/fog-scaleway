require 'securerandom'
require 'unit_test_helper'

class TestIps < Minitest::Test
  def setup
    service = Fog::Scaleway::Compute.new

    @ips = Fog::Scaleway::Compute::Ips.new(service: service)
  end

  def teardown
    Fog::Scaleway::Compute::Mock.reset if Fog.mocking?
  end

  def test_create_ip
    ip = @ips.create

    assert ip.persisted?
  end

  def test_get_ip
    ip = @ips.create

    ip = @ips.get(ip.identity)

    assert ip.persisted?
  end

  def test_get_non_existent_ip
    assert_nil @ips.get(Fog::UUID.uuid)
  end

  def test_get_all_ips
    ip1 = @ips.create
    ip2 = @ips.create

    assert_includes @ips.all, ip1
    assert_includes @ips.all, ip2
  end

  def test_destroy_ip
    ip = @ips.create

    @ips.destroy(ip.identity)

    assert_nil @ips.get(ip.identity)
  end

  def test_destroy_non_existent_ip
    assert_raises Fog::Scaleway::Compute::UnknownResource do
      @ips.destroy(Fog::UUID.uuid)
    end
  end
end
