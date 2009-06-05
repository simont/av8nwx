require 'rubygems'
require 'twibot'
require 'hpricot'  
require 'open-uri'

# Set up the configuration from the file
bot = Twibot::Bot.new(Twibot::Config.default << Twibot::CliConfig.new)

# adds METAR URL:
adds_metar = "http://adds.aviationweather.gov/metars/index.php?submit=1&station_ids="
adds_taf = "http://adds.aviationweather.noaa.gov/tafs/index.php?station_ids="

def get_metar(doc)
  return doc.at("font").inner_html
end

def get_taf(doc)
  return doc.at("pre").inner_html
end

# Receive messages, if they match a METAR request then get the METAR and return it
message "metar :station" do |message, params|
  puts "DM: #{message} info: #{message.sender.screen_name} station: #{params[:station]}"
  metar_url = "#{adds_metar}#{params[:station]}"
  puts "fetching #{metar_url}"
  doc = Hpricot(open(metar_url))
  
  client.message(:post, get_metar(doc), message.sender.screen_name) 
end

# Receive messages, if they match a TAF request then get the TAF and return it
message "taf :station" do |message, params|
  puts "DM: #{message} info: #{message.sender.screen_name} station: #{params[:station]}"
  taf_url = "#{adds_taf}#{params[:station]}"
  puts "fetching #{taf_url}"
  doc = Hpricot(open(taf_url))
  
  client.message(:post, get_taf(doc), message.sender.screen_name) 
end

reply "getwx" do |message, params|
  # if they want to subscribe
  puts "Got subscribe tweet: #{message}"
  
  client.friend(:add, message.user.screen_name)
  client.message(:post, "Hi, av8nwx at your service! Send me DMs like: metar kord or taf klax to get METAR + TAF. PS: Experimental WX, dont rely on this!", message.user.screen_name) 
end