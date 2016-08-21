require 'integration_test_helper'

class TestUsers < Minitest::Test
  def setup
    @users = Fog::Scaleway[:account].users
  end

  def test_update
    user = @users.first

    ssh_public_key = generate_ssh_public_key

    user.ssh_public_keys ||= []
    user.ssh_public_keys << { 'key' => ssh_public_key }
    user.save

    user = @users.get(user.identity)

    assert_includes user.ssh_public_keys.map { |k| k['key'] }, ssh_public_key

    user.ssh_public_keys.reject! { |k| k['key'] == ssh_public_key }
    user.save

    user = @users.get(user.identity)

    refute_includes user.ssh_public_keys.map { |k| k['key'] }, ssh_public_key
  end

  private

  def generate_ssh_public_key
    require 'openssl'
    require 'net/ssh'

    key = OpenSSL::PKey::RSA.new(2048)
    comment = "fog-test-integration-#{self.class}-#{name}"
    "#{key.ssh_type} #{[key.to_blob].pack('m0')} #{comment}"
  end
end
