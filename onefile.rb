#!/usr/bin/env ruby -wKU

require 'net/http'
require 'uri'



def get(url)
  url = URI.parse(url) if url.is_a? String

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true if url.scheme == 'https'

  request = Net::HTTP::Get.new(url.request_uri)
  response = http.request(request)
  response.body
end



url = ARGV.shift

unless url and url.match(/^https?:\/\//)
  raise ArgumentError, 'A valid URL is required.'
end

html = get url

puts html
