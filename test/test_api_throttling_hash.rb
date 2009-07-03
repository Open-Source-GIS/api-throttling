require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class TestApiThrottlingHash < Test::Unit::TestCase
  include Rack::Test::Methods
  include BasicTests
  HASH = Hash.new

  def app
    app = Rack::Builder.new {
      use ApiThrottling, :requests_per_hour => 3, :cache => HASH, :read_method=>"get", :write_method=>"add"
      run lambda {|env| [200, {'Content-Type' =>  'text/plain', 'Content-Length' => '12'}, ["Hello World!"] ] }
    }
  end
  
  def setup
    HASH.replace({})
  end
  
  def test_cache_handler_should_be_memcache
    assert_equal "Handlers::HashHandler", app.to_app.instance_variable_get(:@handler).to_s
  end

end
