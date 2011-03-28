# Query Yahoo's search API

require 'addressable/template'
require 'json'
require 'open-uri'

class Yahoo
  
  @@uri_template = Addressable::Template.new('http://boss.yahooapis.com/ysearch/web/v1/{-list|+|query}/')
  @@search_results_count = 10
  
  attr_accessor :query, :args, :yahoo_api_key
  attr_reader :response_code, :next_page, :total_hits, :deep_hits, :count, :start_page
  
  # key is the API key.
  # query is the string to search for.
  # args can be: :sites, :count
  def initialize(key, query, args={})

    @yahoo_api_key = key
    @query         = query
    @args          = args
    
    @response_code = @next_page = @total_hits = @deep_hits = @count = @start_page = nil
  end
  
  # Build and send the URL using the arguments given when the object is
  # created.
  #
  # Returns a hash containing the results of the search request, or an empty
  # hash if the request fails.
  def search
    args = @args
    args[:sites] = args[:sites].join(',') if (args[:sites] && args[:sites].is_a?(Array))
    
    url = @@uri_template.expand({ :query => @query.split(' ') })
    url.query_values = args.merge(
      :appid  => @yahoo_api_key,
      :count  => args[:count].to_s || @@search_results_count.to_s,
      :format => 'json'
    )
    
    results = JSON.parse(open(url).read)['ysearchresponse'] rescue {}
    if (results.any?)
      @response_code = results['responsecode'].to_i # "200",
      @next_page     = results['nextpage'    ]      # "/ysearch/web/v1/venice/?format=json&count=10&appid=lWng9lHV34FoOSpQrIJ.LLoPa9.eUArpHpy_TIvgKRm9k212e5xleXMk8Su7&start=10",
      @total_hits    = results['totalhits'   ].to_i # "12182222",
      @deep_hits     = results['deephits'    ].to_i # "80300000",
      @count         = results['count'       ].to_i # "10",
      @start_page    = results['start'       ].to_i # "0",
    end
    
    results['resultset_web'] || []
  end
end
