#!/usr/bin/env rspec

require 'addressable/uri'
require 'json'
require 'searchers/google'

describe Google, '#new' do
  it 'creates a new instance' do
    google = Google.new('API_KEY', '', '', '')
    google.class.should == Google
  end
  
  it 'takes a required query with accessors' do
    query = 'query'
    google = Google.new(query, '', '')
    google.query.should == query
    
    google.query = ''
    google.query.should be_empty
  end
  
  it 'takes a required ip_number number with accessors' do
    ip_number = '127.0.0.1'
    google = Google.new('', ip_number, '')
    google.ip_number.should == ip_number
    
    google.ip_number = ''
    google.ip_number.should be_empty
  end
  
  it 'takes a required referrer_site with accessors' do
    referrer_site = 'referrer_site'
    google = Google.new('', '', referrer_site)
    google.referrer_site.should == referrer_site
    
    google.referrer_site = ''
    google.referrer_site.should be_empty
  end
  
  it 'takes optional args with accessors' do
    google = Google.new('', '', '')
    google.args.should be_empty

    google = Google.new('', '', '', {'a' => 1})
    google.args.should == {'a' => 1}
    
    google.args = {'a' => 2}
    google.args.should == {'a' => 2}
  end
  
  it 'creates a instance variable for cursor initialized to nil' do
    google = Google.new('', '', '')
    google.cursor.should be_nil
  end  
end

describe Google, '#search' do
  before(:all) do
    @google = Google.new('"derek trucks"')
    @google_results = @google.search
  end
  
  it 'should return an array that is not empty' do
    @google_results.should be_kind_of(Array)
    @google_results.should_not be_empty
  end
  
  it 'should populate the cursor object' do
    cursor = @google.cursor
    
    cursor.should_not be_nil
    cursor.should be_kind_of(Google::Cursor)
    
    cursor.pages.should be_kind_of(Array)
    
    cursor.estimated_result_count.should be_kind_of(Fixnum)
    cursor.estimated_result_count.should >= 0
    
    cursor.current_page_index.should be_kind_of(Fixnum)
    cursor.current_page_index.should == 0
    
    cursor.more_results_url.should_not be_nil
    cursor.more_results_url.should be_kind_of(String)
    cursor.more_results_url.should_not be_empty
  end
  
end
