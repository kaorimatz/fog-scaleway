require 'unit_test_helper'

class TestTask < Minitest::Test
  def setup
    service = Fog::Scaleway::Compute.new

    servers = Fog::Scaleway::Compute::Servers.new(service: service)
    server = servers.create(
      name: "fog-test-units-#{self.class}-#{name}-1",
      image: X86_64_IMAGE_ID
    )

    @tasks = Fog::Scaleway::Compute::Tasks.new(service: service)
    @task = server.poweron
  end

  def teardown
    Fog::Scaleway::Compute::Mock.reset if Fog.mocking?
  end

  def test_destroy
    @task.destroy

    assert_nil @tasks.get(@task.identity)
  end
end
