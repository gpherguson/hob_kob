require 'yaml'

API_KEYS = {
  bing:   '',
  google: '',
  yahoo:  ''
}

QUERY                = '"king of the blues" + 2011'
SEARCH_RESULTS_COUNT = 10
SITES_TO_CHECK       = %w[guitarcenter.com houseofblues.com]

HAML_FILE     = './king_of_the_blues.haml'
OUTPUT_FILE   = "~/Desktop/#{ QUERY.gsub(/[^\w ]/, '').squeeze(' ').tr(' ', '_') }.html"
REFERRER_SITE = ''

BING_IGNORES       = %w[]
BING_IGNORES_REGEX = []

GOOGLE_IGNORES       = %w[]
GOOGLE_IGNORES_REGEX = []

YAHOO_IGNORES       = %w[ derektrucks.com ]
YAHOO_IGNORES_REGEX = [ 'http://(?:www\.)*guitarcenter\.com' ]


GUITAR_CENTER_IGNORES = %w[
   chickenfoot
   cities.cfm?state=
   gibson-es
   h66316-i1569281
   hal-leonard
   howtobuy.cfm
   king+blues+guitar+chord
   kingoftheblues/rules.cfm
   martin-d12
   new-gear.gc
]
GUITAR_CENTER_IGNORES_REGEX = [ 'interview/(?:derek-trucks|joe-bonamassa)' ]

HOUSE_OF_BLUES_IGNORES = %w[
  38402
  60173
  64195
]
HOUSE_OF_BLUES_IGNORES_REGEX = [ 'eventid=(?:38402|60173|64195)' ]


yaml_haml = {
  api_keys: API_KEYS,

  bing_ignores:       BING_IGNORES,
  bing_ignores_regex: BING_IGNORES_REGEX,

  google_ignores:       GOOGLE_IGNORES,
  google_ignores_regex: GOOGLE_IGNORES_REGEX,

  yahoo_ignores:       YAHOO_IGNORES,
  yahoo_ignores_regex: YAHOO_IGNORES_REGEX,

  guitar_center_ignores:       GUITAR_CENTER_IGNORES,
  guitar_center_ignores_regex: GUITAR_CENTER_IGNORES_REGEX,

  house_of_blues_ignores:       HOUSE_OF_BLUES_IGNORES,
  house_of_blues_ignores_regex: HOUSE_OF_BLUES_IGNORES_REGEX,

  haml_file: HAML_FILE,
  output_file: OUTPUT_FILE,

  query: QUERY,
  referrer_site: REFERRER_SITE,
  search_results_count: SEARCH_RESULTS_COUNT,
  sites_to_check: SITES_TO_CHECK
}

File.open('./king_of_the_blues.yaml', 'w') do |fo|
  fo.puts yaml_haml.to_yaml
end
