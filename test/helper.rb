require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rr'
require 'active_support/all'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'affilinet'

class ActiveSupport::TestCase
  include RR::Adapters::TestUnit
end
