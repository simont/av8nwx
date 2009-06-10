require 'rubygems'
require 'twibot'
require 'hpricot'  
require 'open-uri'

# Set up the configuration from the file
bot = Twibot::Bot.new(Twibot::Config.default << Twibot::CliConfig.new)

# TODO - Check for valid stations, degrade to look for three letter codes if not start with K?
# TODO - Check for valid commands
# TODO - Return helpful message if command or station not recognized

def get_metar(doc)
  response = ""
  begin
    response = doc.at("font").inner_html
  rescue
    response = "Sorry, there was an error processing your request"
  end

  return response
end

def get_taf(doc)
  response = ""
  begin
    response = doc.at("pre").inner_html
  rescue
    response = "Sorry, there was an error processing your request"
  end

  return response
end

def process_metar_message(message, params)
  adds_metar = "http://adds.aviationweather.gov/metars/index.php?submit=1&station_ids="

  puts "DM: #{message} info: #{message.sender.screen_name} station: #{params[:station]}"
  response = ""
  if(validate_station(params[:station]))
    metar_url = "#{adds_metar}#{params[:station]}"
    puts "fetching #{metar_url}"
    doc = Hpricot(open(metar_url))
    response = get_metar(doc)
  else
    response = "#{param[:station]} is not a valid ICAO station identifier"
  end
  client.message(:post, response, message.sender.screen_name)
end

def process_taf_message(message, params)
  adds_taf = "http://adds.aviationweather.noaa.gov/tafs/index.php?station_ids="
  puts "DM: #{message} info: #{message.sender.screen_name} station: #{params[:station]}"
  response = ""
  if(validate_station(params[:station]))
    taf_url = "#{adds_taf}#{params[:station]}"
    puts "fetching #{taf_url}"
    doc = Hpricot(open(taf_url))
    response = get_taf(doc)
  else
    response = "#{param[:station]} is not a valid ICAO station identifier"
  end
  client.message(:post, response, message.sender.screen_name)
end

# Stub for station code valitation
def validate_station(station_code) 
  return true
end


# Receive messages, if they match a METAR request then get the METAR and return it
message "metar :station" do |message, params|
  process_metar_message(message, params)
end

message "m :station" do |message, params|
  process_metar_message(message, params)
end

# Receive messages, if they match a TAF request then get the TAF and return it
message "taf :station" do |message, params|
  process_taf_message(message, params)
end

message "t :station" do |message, params|
  process_taf_message(message, params)
end


# Check for people trying to subscribe to the service
reply "getwx" do |message, params|
  # if they want to subscribe
  puts "Got subscribe tweet: #{message}"

  client.friend(:add, message.user.screen_name)
  client.message(:post, "Hi, av8nwx at your service! Send me DMs like: metar kord or taf klax to get METAR + TAF. PS: Experimental WX, dont rely on this!", message.user.screen_name) 
end