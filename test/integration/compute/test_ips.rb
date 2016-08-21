require 'integration_test_helper'

class TestIps < Minitest::Test
  def setup
    @ips = Fog::Scaleway[:compute].ips
  end

  def test_create_destroy
    ip = @ips.create

    assert_includes @ips.all, ip

    assert_equal ip, @ips.get(ip.identity)

    ip.destroy

    Fog.wait_for { !@ips.all.include?(ip) }

    # Scaleway API returns "Authorization required" error.
    # assert_nil @ips.get(ip.identity)
  end
end
