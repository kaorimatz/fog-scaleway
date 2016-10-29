if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/test/'
  end

  require 'coveralls'
  Coveralls.wear!
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'fog/scaleway'

require 'minitest/autorun'

ENV['FOG_RC'] = ENV['FOG_RC'] || File.expand_path('../.fog', __FILE__)
