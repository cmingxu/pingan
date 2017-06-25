#!/usr/bin/env ruby
# wget -qO- http://hidemyass.com/proxy-list/index.php | ./proxy_getter.rb | head
# http://evilzone.org/security-tools/(bubzuru)-hidemyass-proxy-list-grabber-(alpha)/
# proxy list: http://www.hidemyass.com/proxy-list/
require 'nokogiri'
require 'open-uri'

#doc = Nokogiri::HTML(ARGF.read)
doc = Nokogiri::HTML(open('http://hidemyass.com/proxy-list/index.php'))
rows = doc.xpath('//table[@id="listtable"]/tr')

results = rows.collect do |row|
  result = {}

  row.xpath('td').each_with_index do |td, i|
    case i
    when 1
      good, bytes = [], []
      css = td.at_xpath('span/style/text()').to_s
      css.split.each {|l| good << $1 if l.match(/\.(.+?)\{.*inline/)}
      td.xpath('span/span | span | span/text()').each do |span|
        if span.is_a?(Nokogiri::XML::Text)
          bytes << $1 if span.content.strip.match(/\.{0,1}(.+)\.{0,1}/)
        elsif (
          (span['style'] && span['style'] =~ /inline/) ||
          (span['class'] && good.include?(span['class'])) ||
          (span['class'] =~ /^[0-9]/)
          )

          bytes << span.content
        end
      end

      result[:addr] = bytes.join('.').gsub(/\.+/,'.')
    when 2 then result[:port] = td.content.strip
    when 3 then result[:country] = td.content.strip
    when 4
      result[:response_time] = td.at_xpath('div')["rel"]
      result[:speed] = td.at_xpath('div/div')["class"]
    when 6 then result[:type] = td.content.strip
    when 7
      result[:anonymity] = td.content.strip
    end
  end
  result
end

results.each { |res| puts "#{res[:addr]}\t#{res[:port]}\t#{res[:country]}\t#{res[:speed]}\t#{res[:type]}\t#{res[:anonymity]}" }
