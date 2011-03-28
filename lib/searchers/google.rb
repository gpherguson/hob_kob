# Query Google's search API

require 'addressable/uri'
require 'json'
require 'open-uri'
require 'socket'

class Google
  
  class Cursor
    attr_reader :pages, :estimated_result_count, :current_page_index, :more_results_url
    def initialize(cursor)
      @pages                  = cursor[ 'pages'                ]
      @estimated_result_count = cursor[ 'estimatedResultCount' ].to_i
      @current_page_index     = cursor[ 'currentPageIndex'     ].to_i
      @more_results_url       = cursor[ 'moreResultsUrl'       ]
    end
  end
  
  # Google's search API URL
  @@url = Addressable::URI.parse('http://ajax.googleapis.com/ajax/services/search/web')
  
  attr_accessor :query, :ip_number, :referrer_site, :args, :google_api_key
  attr_reader :response_details, :response_status, :cursor
  
  # key is the API key.
  # query is the string to search for.
  # args can be: :sites
  def initialize(key, query, ip_number = nil, referrer_site = nil, args={})

    @google_api_key = key
    @query          = query
    
    @referrer_site = referrer_site || ''
    @ip_number = ip_number || IPSocket.getaddress(Socket.gethostname)

    @args = args

    @response_details = @response_status = nil
    @cursor = nil
  end
  
  # Build and send the URL using the arguments given when the object is
  # created.
  #
  # Returns a hash containing the results of the search request, or an empty
  # hash if the request fails.
  def search
    url = @@url
    url.query = Addressable::URI.form_encode(
      'v'      => '1.0',
      'q'      => (@args[:site]) ? @query + " site:#{ @args[:site] }" : @query ,
      'key'    => @google_api_key,
      'userip' => @ip_number
    )
    results = JSON.parse(open(url, 'Referer' => @referrer_site).read) rescue {}
    
    @response_details = results['responseDetails'] # => nil,
    @response_status  = results['responseStatus' ] # => 200
    
    @cursor = Cursor.new(results['responseData']['cursor'])
    
    results['responseData']['results']
  end
end
