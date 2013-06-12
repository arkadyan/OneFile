#!/usr/bin/env ruby -wKU

require 'net/http'
require 'net/https'
require 'uri'



def get(url)
  url = URI.parse(url) if url.is_a? String

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true if url.scheme == 'https'

  request = Net::HTTP::Get.new(url.request_uri)
  response = http.request(request)
  response.body
end

def embed_css_inline(html)
  # TODO: Handle relative URLs
  css_regex = /
    <link           # Open the link element opening or self-contained tag
    \s+             # White space between element name and attributes
    .*              # Optional other attributes
    href=           # href attribute where we find the URL
    ["']            # Opening attribute quotes
    (               # Capture the URL for downloading
    https?:\/\/     # http or https
    .+              # Rest of the URL
    \.css           # URL must end with .css
    )               # Finish capturing the URL
    ["']            # Closing attribute quotes
    .*              # Optional other attributes
    \/?             # Optional inline close to the link tag
    >               # End the link element opening or self-contained tag
    (<\/link>)?     # Optional closing link tag
  /x

  html.gsub!(css_regex) do
    css_url = $1
    css_content = get(css_url)
    # TODO: Replace all images in css rules

    styles_code = "<style type='text/css'>\n"
    styles_code << css_content
    styles_code << "</style>\n"
  end
end



url = ARGV.shift

unless url and url.match(/^https?:\/\//)
  raise ArgumentError, 'A valid URL is required.'
end

html = get url

embed_css_inline html

# TODO: Embed javascript files inline

# TODO: Embed images inline with base64 encoding

puts html
