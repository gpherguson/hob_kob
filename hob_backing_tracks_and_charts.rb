#!/usr/bin/env ruby -w

require 'open-uri'
require 'nokogiri'

BASE_DIR = '/Users/greg/Music/HOB backing tracks/'
URL = 'http://gc.guitarcenter.com/kingoftheblues/tracks/'

doc = Nokogiri::HTML(open(URL))

doc.at('div.tracks').search('a').each do |a|
  href = a['href']
  
  case href
    
  when /charts/
    pdf = File.basename(href)
    puts pdf
    
    if (!File.exists?(BASE_DIR + pdf))
      File.open(BASE_DIR + pdf, 'wb') do |fo|
        fo.print(open(URL + href).read)
      end
    end
    
  when /tracks/
    # we don't care right now
    puts a.text
  end
  
end
