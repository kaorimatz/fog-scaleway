# Fog::Scaleway

[![Gem](https://img.shields.io/gem/v/fog-scaleway.svg?style=flat-square)](https://rubygems.org/gems/fog-scaleway)
[![Travis](https://img.shields.io/travis/kaorimatz/fog-scaleway.svg?style=flat-square)](https://travis-ci.org/kaorimatz/fog-scaleway)
[![Coveralls](https://img.shields.io/coveralls/kaorimatz/fog-scaleway.svg?style=flat-square)](https://coveralls.io/github/kaorimatz/fog-scaleway)
[![Gemnasium](https://img.shields.io/gemnasium/kaorimatz/fog-scaleway.svg?style=flat-square)](https://gemnasium.com/kaorimatz/fog-scaleway)

Fog provider gem to support [Scaleway](https://www.scaleway.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fog-scaleway'
```

And then execute:

    $ bundle

## Usage

Put your credentials to the fog configuration file:

```yaml
default:
  scaleway_organization: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx # Your organization ID
  scaleway_token: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx        # Your token
  scaleway_region: par1                                       # par1 or ams1
```

Create a connection to the service:

```ruby
compute = Fog::Compute[:scaleway]
```

Manage servers and resources using the connection:

```ruby
server = compute.servers.bootstrap

server.ssh('uname').first.stdout # => "Linux\r\n"

server.terminate
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test FOG_MOCK=true` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kaorimatz/fog-scaleway.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
