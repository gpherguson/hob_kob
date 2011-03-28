#!/usr/bin/env ruby

require 'addressable/uri'
require 'addressable/template'
require 'cgi'
require 'haml'
require 'json'
require 'logger'
require 'nokogiri'
require 'open-uri'
require 'socket'
require 'yaml'

require_relative 'lib/searchers/bing'
require_relative 'lib/searchers/google'
require_relative 'lib/searchers/yahoo'

class Array
  def downcase
    map{ |e| (e.respond_to?(:downcase)) ? e.downcase : e }
  end

  def to_escaped_str_regex
    return %r{} unless any?
    map{ |e| Regexp.escape(e) rescue e }.to_regex
  end

  def to_regex
    return %r{} unless any?

    Regexp.union(
      map{ |e| Regexp.compile( e, Regexp::IGNORECASE) }
    )
  end
end

YAML_FILE = './king_of_the_blues.yaml'
config = YAML::load_file(YAML_FILE)

API_KEYS = config[:api_keys]

HAML_FILE            = config[ :haml_file            ] # './king_of_the_blues.haml'
QUERY                = config[ :query                ] # '"king of the blues" + 2011'
OUTPUT_FILE          = config[ :output_file          ] # "/Users/greg/Desktop/#{ QUERY.gsub(/[^\w ]/, '').squeeze(' ').tr(' ', '_') }.html"
REFERRER_SITE        = config[ :referrer_site        ] # 'http://eightsecondimagery.com'
SEARCH_RESULTS_COUNT = config[ :search_results_count ]
SITES_TO_CHECK       = config[ :sites_to_check       ] # %w[guitarcenter.com houseofblues.com]

BING_IGNORES           = config[ :bing_ignores           ].to_escaped_str_regex
GOOGLE_IGNORES         = config[ :google_ignores         ].to_escaped_str_regex
YAHOO_IGNORES          = config[ :yahoo_ignores          ].to_escaped_str_regex
GUITAR_CENTER_IGNORES  = config[ :guitar_center_ignores  ].to_escaped_str_regex
HOUSE_OF_BLUES_IGNORES = config[ :house_of_blues_ignores ].map{ |e| 'eventid=' << e }.to_escaped_str_regex

ADDITIONAL_IGNORES = Regexp.union(GUITAR_CENTER_IGNORES, HOUSE_OF_BLUES_IGNORES)

BING_IGNORES_REGEX           = config[ :bing_ignores_regex           ].to_regex
GOOGLE_IGNORES_REGEX         = config[ :google_ignores_regex         ].to_regex
YAHOO_IGNORES_REGEX          = config[ :yahoo_ignores_regex          ].to_regex

GUITAR_CENTER_IGNORES_REGEX  = config[ :guitar_center_ignores_regex  ].to_regex
HOUSE_OF_BLUES_IGNORES_REGEX = config[ :house_of_blues_ignores_regex ].to_regex
ADDITIONAL_IGNORES_REGEX = Regexp.union(GUITAR_CENTER_IGNORES_REGEX, HOUSE_OF_BLUES_IGNORES_REGEX)

GOOGLE_REJECT_LAMBDAS = [
  ->(u) { Nokogiri::HTML(open(u)).at('title').text[/King of the Blues 2010/i] }
]
  
# used by Google
IP_NUMBER = IPSocket.getaddress(`hostname`.chomp) # '98.165.218.177'

log = Logger.new($0 + '.log', 'monthly')

# check Google...
google = Google.new(API_KEYS[:google], '', IP_NUMBER, REFERRER_SITE, 'num' => SEARCH_RESULTS_COUNT.to_s)
google.query = QUERY + ' ' + SITES_TO_CHECK.map{ |s| "site:#{ s }" }.join(' OR ')
search_regex = Regexp.union(GOOGLE_IGNORES_REGEX, ADDITIONAL_IGNORES_REGEX, GOOGLE_IGNORES, ADDITIONAL_IGNORES)
google_search_results = google.search().reject { |o| search_regex =~ o['unescapedUrl'] }
google_search_results.reject!{ |_result| 
  GOOGLE_REJECT_LAMBDAS.any?{ |l| 
    l.call(_result['unescapedUrl']) 
  } 
}

# check YAHOO...
yahoo_search_results = Yahoo.new(API_KEYS[:yahoo], QUERY, :sites => SITES_TO_CHECK).search()
search_regex = Regexp.union(YAHOO_IGNORES_REGEX, ADDITIONAL_IGNORES_REGEX, YAHOO_IGNORES, ADDITIONAL_IGNORES)
yahoo_search_results = yahoo_search_results.reject { |o| o['url'] =~ search_regex }

# Bing's results don't honor the site and end up returning a bunch of
# false-positives, so they're outta-here.
#
# check Bing...
# bing_search_results = Bing.new(API_KEYS[:bing], QUERY, 'Web.Count' => SEARCH_RESULTS_COUNT.to_s).search()['Web']['Results']
# search_regex = Regexp.union(BING_IGNORES_REGEX, BING_IGNORES, ADDITIONAL_IGNORES)
bing_search_results = []

if (
  google_search_results.any? ||
  yahoo_search_results.any?  ||
  bing_search_results.any?
)
  log.info("#{ google_search_results.size } pages found on Google")
  log.info("#{ yahoo_search_results.size  } pages found on Yahoo")
  log.info("#{ bing_search_results.size   } pages found on Bing")

  engine = Haml::Engine.new(File.read(HAML_FILE))
  File.open(OUTPUT_FILE, 'w') do |fo|
    fo.puts engine.render(
      Object.new, 
      :google_search_results => google_search_results, 
      :yahoo_search_results  => yahoo_search_results,
      :bing_search_results   => bing_search_results
    )
  end
else
  log.info("No articles found on Google or Yahoo.")
end

