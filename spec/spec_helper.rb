$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'test_harness'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

TestHarness.configure do |c|
  c.namespace = 'FakeHarness'
  c.autoload_path = File.expand_path('../fake_harness', __FILE__)
end

RSpec.configure do |config|
  
end
