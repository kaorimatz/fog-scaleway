if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/test/'
  end

  require 'coveralls'
  Coveralls.wear!
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'fog/scaleway'

require 'minitest/autorun'

ENV['FOG_RC'] ||= File.expand_path('.fog', __dir__)

X86_64_IMAGE_ID = '75c28f52-6c64-40fc-bb31-f53ca9d02de9'.freeze
ARM_IMAGE_ID    = 'eeb73cbf-78a9-4481-9e38-9aaadaf8e0c9'.freeze
