require 'minitest/autorun'

require 'addressable/uri'
require 'addressable/template'
require 'json'
require 'searchers/yahoo'

QUERY = 'yahoo'
SITES_TO_CHECK = %w[yahoo.com]

class Yahoo < MiniTest::Unit::TestCase

  def test_new
    yahoo = Yahoo.new('API_KEY', '')

    assert_kind_of(Yahoo, yahoo.class)
  end
  
  def test_query
    query = 'query'
    yahoo = Yahoo.new(query)

    assert_equal(query, yahoo.query)
    
    yahoo.query = ''
    assert_empty(yahoo.query)
  end
  
  def test_args
    yahoo = Yahoo.new('')
    assert_equal({}, yahoo.args)
    
    yahoo.args = {:a => 1}
    assert_equal({:a => 1}, yahoo.args)
  end
  
  def test_response_code
    yahoo = Yahoo.new('')
    
    assert_nil(yahoo.response_code)
  end

  def test_next_page
    yahoo = Yahoo.new('')

    assert_nil(yahoo.next_page)
  end

  def test_total_hits
    yahoo = Yahoo.new('')

    assert_nil(yahoo.total_hits)
  end

  def test_deep_hits
    yahoo = Yahoo.new('')

    assert_nil(yahoo.deep_hits)
  end

  def test_count
    yahoo = Yahoo.new('')

    assert_nil(yahoo.count)
  end

  def test_start_page
    yahoo = Yahoo.new('')

    assert_nil(yahoo.start_page)
  end
  
  def test_results
    yahoo = Yahoo.new(QUERY, :sites => SITES_TO_CHECK)
    yahoo_results = yahoo.search

    refute_empty(yahoo_results)
    assert_kind_of(Array, yahoo_results)
  end
    
  def test_response_code
    yahoo = Yahoo.new(QUERY, :sites => SITES_TO_CHECK)

    refute_nil(yahoo.response_code)
    assert_kind_of(Fixnum, yahoo.response_code)
  end

  def test_next_page
    yahoo = Yahoo.new(QUERY, :sites => SITES_TO_CHECK)
    
    refute_nil(yahoo.next_page)
    assert_kind_of(String, yahoo.next_page)
  end

  def test_total_hits
    yahoo = Yahoo.new(QUERY, :sites => SITES_TO_CHECK)

    refute_nil(yahoo.total_hits)
    assert_kind_of(Fixnum, yahoo.total_hits)
  end

  def test_deep_hits
    yahoo = Yahoo.new(QUERY, :sites => SITES_TO_CHECK)

    refute_nil(yahoo.deep_hits)
    assert_kind_of(Fixnum, yahoo.deep_hits)
  end

  def test_count
    yahoo = Yahoo.new(QUERY, :sites => SITES_TO_CHECK)
    
    refute_nil(yahoo.count)
    assert_kind_of(Fixnum, yahoo.count)
  end

  def test_start_page
    yahoo = Yahoo.new(QUERY, :sites => SITES_TO_CHECK)

    refute_nil(yahoo.start_page)
    assert_kind_of(Fixnum, yahoo.start_page)
  end
end
