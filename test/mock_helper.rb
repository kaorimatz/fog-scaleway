# Use so you can run in mock mode from the command line
#
# FOG_MOCK=true fog

Fog.mock! if ENV['FOG_MOCK'] == 'true'

# if in mocked mode, fill in some fake credentials for us
if Fog.mock?
  Fog.credentials = {
    scaleway_organization: '7c91ef18-eea8-4f4f-bfca-deaea872338c',
    scaleway_token: '04b66719-36f4-4dfc-a345-f20db6175a8f',
    scaleway_email: 'scaleway@example.com'
  }.merge(Fog.credentials)
end
