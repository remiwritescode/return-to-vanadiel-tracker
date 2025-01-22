#! /usr/bin/env ruby

require 'faraday'
require 'nokogiri'
require 'time'

RETURN_TO_VANADIEL_CAMPAIGN_CONFIG_XML_URL = 'http://www.playonline.com/ff11/campaign/wcb/i18n/_common.xml'.freeze
JAPANESE_DATE_REGEX = /(?<year>\d+)年(?<month>\d+)月(?<day>\d+)日/.freeze
CAMPAIGN_DATE_STORAGE_FILE = './campaign_date.txt'
LAST_CAMPAIGN_DATE = File.read(CAMPAIGN_DATE_STORAGE_FILE)

conn = Faraday.new()
response = conn.get do |req|
  req.url RETURN_TO_VANADIEL_CAMPAIGN_CONFIG_XML_URL
  # req.params['__taco__'] = Time.now.utc.to_i * 1000
  req.headers['Accept'] = 'application/xml'
  req.headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 14.7; rv:134.0) Gecko/20100101 Firefox/134.0'
end

data = Nokogiri.parse(response.body)
campaign_start_date_string = data.xpath("//var[@name='campaign_start_date' and @type='jp']").children.first.text
parsed_start_date_string = campaign_start_date_string.match(JAPANESE_DATE_REGEX)
campaign_start_date = Date.new(
  parsed_start_date_string[:year].to_i,
  parsed_start_date_string[:month].to_i,
  parsed_start_date_string[:day].to_i
) + 1
# It looks like the date may be two weeks after this date from the current campaign at the time of writing.

if campaign_start_date > Date.parse(LAST_CAMPAIGN_DATE)
  `osascript -e 'tell app (path to frontmost application as text) to display dialog "A new Free FFXI Login Campaign is coming on #{campaign_start_date.to_s}!"'`
  File.write(CAMPAIGN_DATE_STORAGE_FILE, campaign_start_date.to_s)
end
