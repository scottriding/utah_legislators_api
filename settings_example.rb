require 'rubygems'
require 'sinatra'
require 'sequel'

SETTINGS = {
  # Put DB endpoint here
  :db => Sequel.connect('postgres://username@localhost:5432/db_name'),
  
  # Utah AGRC Geocoder API information
  :agrc_geocoder_endpoint => 'http://dagrc.utah.gov/Beta/WebApi/api/v1/Geocode/',
  :agrc_api_key => 'your-key-here',
  :agrc_referer_url => 'http://your-url.com',
  
  # GIS settings
  :spatial_ref => 26912
}
