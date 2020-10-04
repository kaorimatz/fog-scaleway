require 'integration_test_helper'

class TestServers < Minitest::Test
  def setup
    @servers = Fog::Scaleway[:compute].servers
    @volumes = Fog::Scaleway[:compute].volumes
    @ips = Fog::Scaleway[:compute].ips
  end

  def test_create_update_destroy
    server = @servers.create(
      name: "fog-test-integration-#{self.class}-#{name}",
      image: X86_64_IMAGE_ID
    )

    assert_includes @servers.all, server

    assert_equal server, @servers.get(server.identity)

    server.enable_ipv6 = true
    server.name = "fog-test-integration-#{self.class}-#{name}-updated"
    server.tags = %w[tag1 tag2 tag3]
    server.save

    server = @servers.get(server.identity)

    assert_equal true, server.enable_ipv6
    assert_equal "fog-test-integration-#{self.class}-#{name}-updated", server.name
    assert_equal %w[tag1 tag2 tag3], server.tags

    server.destroy

    Fog.wait_for { !@servers.all.include?(server) }

    assert_nil @servers.get(server.identity)

    server.volumes.each_value(&:destroy)
    server.volumes.each_value { |v| Fog.wait_for { !@volumes.all.include?(v) } }
  end

  def test_poweron_poweroff_reboot_terminate
    server = @servers.create(
      name: "fog-test-integration-#{self.class}-#{name}",
      image: X86_64_IMAGE_ID
    )

    assert_equal 'stopped', server.state

    server.poweron(async: false)

    assert_equal 'running', server.state

    server.poweroff(async: false)

    assert_equal 'stopped', server.state

    server.poweron(async: false)

    assert_equal 'running', server.state

    server.reboot(async: false)

    assert_equal 'running', server.state

    server.terminate(async: false)

    assert_nil @servers.get(server.identity)
  end

  def test_attach_volume_detach_volume
    server = @servers.create(
      name: "fog-test-integration-#{self.class}-#{name}",
      image: X86_64_IMAGE_ID
    )

    volume = @volumes.create(
      name: "fog-test-integration-#{self.class}-#{name}",
      size: 50_000_000_000,
      volume_type: 'l_ssd'
    )

    server.attach_volume(volume)

    assert_includes server.volumes.values, volume

    volume.reload

    assert_equal server, volume.server

    server.detach_volume(volume)

    refute_includes server.volumes.values, volume

    volume.reload

    assert_nil volume.server

    server.destroy
    server.volumes.each_value(&:destroy)
    volume.destroy

    Fog.wait_for { !@servers.all.include?(server) }
    server.volumes.each_value { |v| Fog.wait_for { !@volumes.all.include?(v) } }
    Fog.wait_for { !@volumes.all.include?(volume) }
  end

  def test_bootstrap_ssh
    server = @servers.bootstrap(
      name: "fog-test-integration-#{self.class}-#{name}"
    )

    assert server.sshable?

    unless Fog.mocking?
      result = server.ssh('uname').first

      assert_equal 0, result.status
      assert_match(/Linux/, result.stdout)
    end

    server.terminate(async: false)

    server.public_ip.destroy

    Fog.wait_for { !@ips.all.include?(server.public_ip) }
  end
end
