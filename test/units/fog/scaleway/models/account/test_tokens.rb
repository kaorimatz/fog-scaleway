require 'securerandom'
require 'unit_test_helper'

class TestTokens < Minitest::Test
  def setup
    service = Fog::Scaleway::Account.new

    @tokens = Fog::Scaleway::Account::Tokens.new(service: service)
  end

  def teardown
    Fog::Scaleway::Account::Mock.reset if Fog.mocking?
  end

  def test_create_token
    token = @tokens.create

    assert token.persisted?
  end

  def test_get_token
    token = @tokens.create

    token = @tokens.get(token.identity)

    assert token.persisted?
  end

  def test_get_non_existent_token
    assert_nil @tokens.get(Fog::UUID.uuid)
  end

  def test_get_all_tokens
    token1 = @tokens.create
    token2 = @tokens.create

    assert_includes @tokens.all, token1
    assert_includes @tokens.all, token2
  end

  def test_destroy_token
    token = @tokens.create

    @tokens.destroy(token.identity)

    assert_nil @tokens.get(token.identity)
  end

  def test_destroy_non_existent_token
    assert_raises Fog::Scaleway::Account::UnknownResource do
      @tokens.destroy(Fog::UUID.uuid)
    end
  end
end
