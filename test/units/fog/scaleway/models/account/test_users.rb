require 'securerandom'
require 'unit_test_helper'

class TestUsers < Minitest::Test
  def setup
    service = Fog::Scaleway::Account.new

    @users = Fog::Scaleway::Account::Users.new(service: service)
  end

  def teardown
    Fog::Scaleway::Account::Mock.reset if Fog.mocking?
  end

  def test_get_user
    user = @users.get('e9459194-0f66-4958-b3c3-01e623d21566')

    assert user.persisted?
  end

  def test_get_non_existent_user
    assert_nil @users.get(Fog::UUID.uuid)
  end

  def test_get_all_users
    user = @users.get('e9459194-0f66-4958-b3c3-01e623d21566')

    assert_includes @users, user
  end
end
