#!/usr/bin/env rspec

require 'addressable/uri'
require 'json'
require 'open-uri'
require 'searchers/bing'

describe Bing, '#new' do
  
  it 'creates a new instance' do
    bing = Bing.new('')
    bing.should be_kind_of(Bing)
  end
  
  it 'has a query that can be accessed via accessors' do
    query = 'query'
    
    bing = Bing.new(query)
    bing.query.should == query
    
    bing.query = ''
    bing.query.should be_empty
  end
  
  it 'has args that can be accessed via accessors' do
    arguments = {'one' => 1, 'two' => 2}
    
    bing = Bing.new('', arguments)
    bing.args.should == arguments
    
    bing.args = {}
    bing.args.should == {}
  end
end

describe Bing, '#search' do
end