require 'securerandom'
require 'unit_test_helper'

class TestOrganizations < Minitest::Test
  def setup
    service = Fog::Scaleway::Account.new

    @organizations = Fog::Scaleway::Account::Organizations.new(service: service)
  end

  def teardown
    Fog::Scaleway::Account::Mock.reset if Fog.mocking?
  end

  def test_get_organization
    organization = @organizations.get('7c91ef18-eea8-4f4f-bfca-deaea872338c')

    assert organization.persisted?
  end

  def test_get_non_existent_organization
    assert_nil @organizations.get(Fog::UUID.uuid)
  end

  def test_get_all_organizations
    organization = @organizations.get('7c91ef18-eea8-4f4f-bfca-deaea872338c')

    assert_includes @organizations, organization
  end
end
