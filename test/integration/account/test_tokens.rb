require 'test_helper'

class TestTokens < Minitest::Test
  def setup
    @tokens = Fog::Scaleway[:account].tokens
  end

  def test_create_update_destroy
    token = @tokens.create

    assert_includes @tokens.all, token

    assert_equal token, @tokens.get(token.identity)

    token.description = "fog-test-integration-#{self.class}-#{name}-updated"
    token.save

    token = @tokens.get(token.identity)

    assert_equal "fog-test-integration-#{self.class}-#{name}-updated", token.description

    token.destroy

    Fog.wait_for { !@tokens.all.include?(token) }

    assert_nil @tokens.get(token.identity)
  end
end
