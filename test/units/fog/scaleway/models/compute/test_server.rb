require 'unit_test_helper'

class TestServer < Minitest::Test
  def setup
    @service = Fog::Scaleway::Compute.new

    @volumes = Fog::Scaleway::Compute::Volumes.new(service: @service)

    @servers = Fog::Scaleway::Compute::Servers.new(service: @service)
    @server = @servers.new(
      commercial_type: 'C1',
      name: "fog-test-integration-#{self.class}-#{name}",
      image: ARM_IMAGE_ID
    )
  end

  def teardown
    Fog::Scaleway::Compute::Mock.reset if Fog.mocking?
  end

  def test_save
    @server.save

    assert @server.persisted?

    @server.name = "fog-test-units-#{self.class}-#{name}-updated"

    @server.save

    assert_equal "fog-test-units-#{self.class}-#{name}-updated", @server.name
  end

  def test_destroy
    @server.save

    @server.destroy

    assert_nil @servers.get(@server.identity)
  end

  def test_poweron
    @server.save

    @server.poweron(false)

    assert @server.state == 'running'
  end

  def test_poweroff
    @server.save

    @server.poweron(false)

    @server.poweroff(false)

    assert @server.state == 'stopped'
  end

  def test_reboot
    @server.save

    @server.poweron(false)

    @server.reboot(false)

    assert @server.state == 'running'
  end

  def test_terminate
    @server.save

    @server.poweron(false)

    @server.terminate(false)

    assert_nil @servers.get(@server.identity)
  end

  def test_attach_volume
    @server.save

    volume = @volumes.create(
      name: "fog-test-units-#{self.class}-#{name}",
      size: 50_000_000_000,
      volume_type: 'l_ssd'
    )

    @server.attach_volume(volume)

    assert_equal @server.volumes['1'], volume
  end

  def test_detach_volume
    @server.save

    volume = @volumes.create(
      name: "fog-test-units-#{self.class}-#{name}",
      size: 50_000_000_000,
      volume_type: 'l_ssd'
    )

    @server.attach_volume(volume)

    @server.detach_volume(volume)

    assert_nil @server.volumes['1']
  end
end
