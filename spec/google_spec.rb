require 'minitest/autorun'

require 'addressable/uri'
require 'json'
require 'yaml'
require_relative '../lib/searchers/google'

 
class TestGoogle < MiniTest::Unit::TestCase 

  def test_new 
    google = Google.new('key', 'query')
    assert_kind_of(Google, google)
  end
  
  def test_query 
    query = 'query'
    google = Google.new('key', query)
    assert_equal(query, google.query)
    
    google.query = ''
    assert_empty(google.query)
    assert_equal('', google.query)
  end
  
  def test_ip_number
    ip_number = '127.0.0.1'

    google = Google.new('key', 'query', ip_number)
    assert_equal(ip_number, google.ip_number)
    
    google.ip_number = ''
    assert_empty(google.ip_number)
  end
  
  def test_referrer_site
    referrer_site = 'referrer_site'

    google = Google.new('key', 'query', 'ip', referrer_site)
    assert_equal(referrer_site, google.referrer_site)
    
    google.referrer_site = ''
    assert_empty(google.referrer_site)
  end
  
  def test_args
    google = Google.new('key', 'query', 'ip')

    assert_empty(google.args)

    google = Google.new('key', 'query', 'ip', 'referrer_site', {'a' => 1})
    assert_equal({'a' => 1}, google.args)
    
    google.args = {'a' => 2}
    assert_equal({'a' => 2}, google.args)
  end
  
  def test_cursor
    google = Google.new('key', 'query')

    assert_nil(google.cursor)
  end  

  def test_google_results
    config = YAML::load_file('../king_of_the_blues.yaml')

    google = Google.new(config[:api_keys][:google],'"derek trucks"')

    google_results = google.search
    assert_kind_of(Array, google_results)
    refute_empty(google_results)
  end
  
  # def test_cursor
  #   google = Google.new('key','query')
  #   cursor = google.cursor
  #   
  #   assert_nil(cursor)
  #   # assert_kind_of(Google::Cursor, cursor)
  #   
  #   assert_kind_of(Array, cursor.pages)
  #   
  #   assert_kind_of(Fixnum, cursor.estimated_result_count)
  #   assert(cursor.estimated_result_count >= 0)
  #   
  #   assert_kind_of(Fixnum, cursor.current_page_index)
  #   assert_equal(cursor.current_page_index, 0)
  #   
  #   refute_nil(cursor.more_results_url)
  #   assert_kind_of(String, cursor.more_results_url)
  #   refute_empty(cursor.more_results_url)
  # end
  
end
