require 'unit_test_helper'

class TestToken < Minitest::Test
  def setup
    @service = Fog::Scaleway::Account.new

    @tokens = Fog::Scaleway::Account::Tokens.new(service: @service)
    @token = @tokens.new
  end

  def teardown
    Fog::Scaleway::Account::Mock.reset if Fog.mocking?
  end

  def test_save
    @token.save

    assert @token.persisted?

    @token.description = "fog-test-units-#{self.class}-#{name}-updated"

    @token.save

    assert_equal "fog-test-units-#{self.class}-#{name}-updated", @token.description
  end

  def test_destroy
    @token.save

    @token.destroy

    assert_nil @tokens.get(@token.identity)
  end
end
