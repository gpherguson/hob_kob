#!/usr/bin/env ruby -w

require 'httpclient'
require 'nokogiri'

BASE_DIR  = '/Users/greg/Music/HOB backing tracks/'
URL       = 'http://gc.guitarcenter.com/kingoftheblues/tracks/index.cfm?track='

def get_file(href)

  fname = File.basename(href)
  print fname

  if (File.exists?(BASE_DIR + fname))

    puts " exists, skipping."

  else 

    print " downloading..."

    File.open(BASE_DIR + fname, 'wb') do |fo|

      uri = URI.parse(URL).merge(href)
      fo.print(HTTPClient.get_content(uri.to_s))

    end

    puts " done"

  end
end

1.upto(30) do |i|
  doc = Nokogiri::HTML(HTTPClient.get_content(URL + i.to_s))

  doc.search('a').select{ |a| a['href'][/\.(?:zip|pdf)$/] }.each do |a|
    get_file(a['href'])
  end

end
