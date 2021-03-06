require 'rubygems'
require 'sinatra'
require 'sequel'

SETTINGS = {
  # Put DB endpoint here
  :db => Sequel.connect(ENV['DATABASE_URL']),
  
  # Utah AGRC Geocoder API information
  :agrc_geocoder_endpoint => ENV['AGRC_GEOCODER_ENDPOINT'],
  :agrc_api_key => ENV['AGRC_API_KEY'],
  
  # GIS settings
  :spatial_ref => 26912
}

SETTINGS[:agrc_referer_url] = ENV['AGRC_REFERER_URL'] unless ENV['AGRC_REFERER_URL'].nil?
