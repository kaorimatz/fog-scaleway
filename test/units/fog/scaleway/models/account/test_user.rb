require 'unit_test_helper'

class TestUser < Minitest::Test
  def setup
    @service = Fog::Scaleway::Account.new

    @users = Fog::Scaleway::Account::Users.new(service: @service)
    @user = @users.get('e9459194-0f66-4958-b3c3-01e623d21566')
  end

  def teardown
    Fog::Scaleway::Account::Mock.reset if Fog.mocking?
  end

  def test_save
    @user.phone_number = '+33 1 23 45 67 89'
    @user.firstname = 'firstname'
    @user.lastname = 'lastname'

    @user.save

    assert_equal '+33 1 23 45 67 89', @user.phone_number
    assert_equal 'firstname', @user.firstname
    assert_equal 'lastname', @user.lastname
  end
end
