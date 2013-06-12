#!/usr/bin/env ruby -wKU

url = ARGV.shift

unless url and url.match(/^https?:\/\//)
  raise ArgumentError, 'A valid URL is required.'
end

puts url
