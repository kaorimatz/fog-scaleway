if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/test/'
  end
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'fog/scaleway'

require 'minitest/autorun'
