#!/usr/bin/env rspec

require 'addressable/uri'
require 'addressable/template'
require 'json'
require 'searchers/yahoo'

QUERY = 'yahoo'
SITES_TO_CHECK = %w[yahoo.com]

describe Yahoo, '#new' do
  it 'should create a new instance' do
    yahoo = Yahoo.new('')
    yahoo.class.should == Yahoo
  end
  
  it 'has a required query parameter with accessors' do
    query = 'query'
    yahoo = Yahoo.new(query)
    yahoo.query.should == query
    
    yahoo.query = ''
    yahoo.query.should be_empty
  end
  
  it 'has an optional args parameter with accessors' do
    yahoo = Yahoo.new('')
    yahoo.args.should == {}
    
    yahoo.args = {:a => 1}
    yahoo.args.should == {:a => 1}
  end
  
  it 'has search results set to nil when initialized' do
    yahoo = Yahoo.new('')
    
    yahoo.response_code.should be_nil
    yahoo.next_page.should be_nil
    yahoo.total_hits.should be_nil
    yahoo.deep_hits.should be_nil
    yahoo.count.should be_nil
    yahoo.start_page.should be_nil
  end
  
end

describe Yahoo, '#search' do
  it 'should get content as a hash and populate result values' do
    yahoo = Yahoo.new(QUERY, :sites => SITES_TO_CHECK)
    yahoo_results = yahoo.search
    yahoo_results.should_not be_empty
    yahoo_results.class.should be_kind_of(Array)
    
    yahoo.response_code.should_not be_nil
    yahoo.response_code.should be_a_kind_of(Fixnum)
    
    yahoo.next_page.should_not be_nil
    yahoo.next_page.should be_a_kind_of(String)

    yahoo.total_hits.should_not be_nil
    yahoo.total_hits.should be_a_kind_of(Fixnum)

    yahoo.deep_hits.should_not be_nil
    yahoo.deep_hits.should be_a_kind_of(Fixnum)
    
    yahoo.count.should_not be_nil
    yahoo.count.should be_a_kind_of(Fixnum)

    yahoo.start_page.should_not be_nil
    yahoo.start_page.should be_a_kind_of(Fixnum)
  end
end
