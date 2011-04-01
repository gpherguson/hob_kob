require 'minitest/autorun'

require 'addressable/uri'
require 'addressable/template'
require 'json'
require 'yaml'
require_relative '../lib/searchers/yahoo'

QUERY = 'yahoo'
SITES_TO_CHECK = %w[ yahoo.com ]

class TestYahoo < MiniTest::Unit::TestCase

  def test_new
    yahoo = Yahoo.new('key', 'query')

    assert_kind_of(Yahoo, yahoo)
  end
  
  def test_query
    query = 'query'
    yahoo = Yahoo.new('key', query)

    assert_equal(query, yahoo.query)
    
    yahoo.query = ''
    assert_empty(yahoo.query)
  end
  
  def test_args
    yahoo = Yahoo.new('key','query')
    assert_equal({}, yahoo.args)
    
    yahoo.args = {:a => 1}
    assert_equal({:a => 1}, yahoo.args)
  end
  
  def test_response_code
    yahoo = Yahoo.new('key','query')
    
    # move down
  end

  def test_next_page
    yahoo = Yahoo.new('key','query')

    # move down
  end

  def test_total_hits
    yahoo = Yahoo.new('key','query')

    # move down
  end

  def test_deep_hits
    yahoo = Yahoo.new('key','query')

    # move down
  end

  def test_count
    yahoo = Yahoo.new('key','query')

    # move down
  end

  def test_start_page
    yahoo = Yahoo.new('key','query')

    # move down
  end
  
  def test_results
    config = YAML::load_file('../king_of_the_blues.yaml')
    yahoo = Yahoo.new(config[:api_keys][:yahoo], QUERY, :sites => SITES_TO_CHECK)

    yahoo_results = yahoo.search

    refute_nil(yahoo.response_code)
    assert_kind_of(Fixnum, yahoo.response_code)
    assert_equal(200, yahoo.response_code)

    refute_nil(yahoo.next_page)
    assert_kind_of(String, yahoo.next_page)
    refute_empty(yahoo.next_page)

    refute_nil(yahoo.total_hits)
    assert_kind_of(Fixnum, yahoo.total_hits)
    assert(yahoo.count >= 0)

    refute_nil(yahoo.deep_hits)
    assert_kind_of(Fixnum, yahoo.deep_hits)
    assert(yahoo.count >= 0)

    refute_nil(yahoo.count)
    assert_kind_of(Fixnum, yahoo.count)
    assert(yahoo.count >= 0)

    refute_nil(yahoo.start_page)
    assert_kind_of(Fixnum, yahoo.start_page)
    assert_equal(0, yahoo.start_page)
  end
end
