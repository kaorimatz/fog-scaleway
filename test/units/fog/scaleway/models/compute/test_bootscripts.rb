require 'securerandom'
require 'unit_test_helper'

class TestBootscripts < Minitest::Test
  def setup
    service = Fog::Scaleway::Compute.new

    @bootscripts = Fog::Scaleway::Compute::Bootscripts.new(service: service)
  end

  def teardown
    Fog::Scaleway::Compute::Mock.reset if Fog.mocking?
  end

  def test_get_bootscript
    bootscript = @bootscripts.get('3b522e7a-8468-4577-ab3e-2b9535384bb8')

    assert bootscript.persisted?
  end

  def test_get_non_existent_bootscript
    assert_nil @bootscripts.get(Fog::UUID.uuid)
  end

  def test_get_all_bootscripts
    bootscript = @bootscripts.get('3b522e7a-8468-4577-ab3e-2b9535384bb8')

    assert_includes @bootscripts, bootscript
  end
end
