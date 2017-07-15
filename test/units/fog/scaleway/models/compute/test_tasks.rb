require 'securerandom'
require 'unit_test_helper'

class TestTasks < Minitest::Test
  def setup
    service = Fog::Scaleway::Compute.new

    servers = Fog::Scaleway::Compute::Servers.new(service: service)
    @server1 = servers.create(
      name: "fog-test-units-#{self.class}-#{name}-1",
      image: X86_64_IMAGE_ID
    )
    @server2 = servers.create(
      name: "fog-test-units-#{self.class}-#{name}-2",
      image: X86_64_IMAGE_ID
    )

    @tasks = Fog::Scaleway::Compute::Tasks.new(service: service)
  end

  def teardown
    Fog::Scaleway::Compute::Mock.reset if Fog.mocking?
  end

  def test_get_task
    task = @server1.poweron

    task = @tasks.get(task.identity)

    assert task.persisted?
  end

  def test_get_non_existent_task
    assert_nil @tasks.get(Fog::UUID.uuid)
  end

  def test_get_all_tasks
    task1 = @server1.poweron
    task2 = @server2.poweron

    assert_includes @tasks.all, task1
    assert_includes @tasks.all, task2
  end

  def test_destroy_non_existent_task
    assert_raises Fog::Scaleway::Compute::UnknownResource do
      @tasks.destroy(Fog::UUID.uuid)
    end
  end
end
