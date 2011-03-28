# Query Microsoft's Bing search API.

require 'addressable/uri'
require 'open-uri'

class Bing
  @@url = Addressable::URI.parse('http://api.bing.net/json.aspx?Version=2.2&Market=en-US&Sources=web&Web.Count=5&JsonType=raw')
  
  attr_accessor :query, :args, :bing_api_key
  
  # app_id is what what most APIs call the API key. 
  def initialize(key, query, args={})

    @bing_api_key = key
    @query        = query
    @args         = args

  end
  
  # Build and send the URL using the arguments given when the object is
  # created.
  #
  # Returns a hash containing the results of the search request, or an empty
  # hash if the request fails.
  def search
    url = @@url
    url.query_values = url.query_values.merge(@args).merge(
      'AppId' => @bing_api_key,
      'Query' => @query
    )
    results = JSON.parse(open(url).read) rescue {}
    results['SearchResponse']['Web']['Results'] || {}
  end
end
