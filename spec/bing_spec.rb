require 'minitest/autorun'

require 'addressable/uri'
require 'json'
require 'open-uri'
require_relative '../lib/searchers/bing'

class TestBing < MiniTest::Unit::TestCase
  
  def test_new 
    b = Bing.new(*%w[ key query ])
    assert_kind_of(Bing, b)
  end
  
  def test_query 
    query = 'query'
    
    bing = Bing.new(*%w[ key query ])
    assert_equal(query, bing.query)
    
    bing.query = ''
    assert_equal('', bing.query)
  end
  
  def test_args 
    arguments = {'one' => 1, 'two' => 2}
    
    bing = Bing.new(*%w[ key query ], arguments)
    assert_equal(arguments, bing.args)
    
    bing.args = {}
    assert_equal({}, bing.args)
  end
end
