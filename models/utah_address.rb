require 'rubygems'
require 'open-uri'
require 'rest-client'
require 'singleton'
require 'json'

module UtahAddress

  def self.geocode(address, area)
    ut_geocoder = UtahGeocoder.instance
    ut_geocoder.geocode(address, area)
  end
  
  class UtahGeocoder
  
    include Singleton
  
    def geocode(address, area)
      response = request_geocodes(address, area)
      check_response(response)
      parse_response(response)
    end
    
    private
    
    def request_geocodes(address, area)
    
      raise AddressError.new('Missing address.') unless valid?(address)
      raise AreaError.new('Missing city or zip code.') unless valid?(area)
      
      query_settings = {
        :params => {
          :apiKey => SETTINGS[:agrc_api_key],
          :suggest => 0
        },
        :accept => 'application/json'
      }
      query_settings['referer'] = SETTINGS[:agrc_referer_url] unless SETTINGS[:agrc_referer_url].nil?
      
      begin
        response = RestClient.get(
          "#{SETTINGS[:agrc_geocoder_endpoint]}/#{encode(address)}/#{encode(area)}",
          query_settings
        )
        JSON.parse(response.body)
      
      rescue RestClient::ServiceUnavailable
        raise ServiceError.new('Geocoding service is temporarily unavailable.')
      end
    
    end
    
    def check_response(response)
      case response['status']
      when 404
        raise GeocodeError.new(
          'Unable to geocode address. Check city spelling or use zip code.'
        )
      when 500
        raise GeocodeError.new(
          'There is a temporary error with the AGRC geocoding service. Please try again later.'
        ) 
      end
    end
    
    def parse_response(response)
      {
        :input_address => input_address(response),
        :match_address => match_address(response),
        :latitude => latitude(response),
        :longitude => longitude(response),
        :spatial_reference_key => SETTINGS[:spatial_ref]
      }
    end
    
    def input_address(response)
      response['result']['inputAddress']
    end
    
    def match_address(response)
      response['result']['matchAddress']
    end
    
    def latitude(response)
      response['result']['location']['y']
    end
    
    def longitude(response)
      response['result']['location']['x']
    end
    
    def valid?(parameter)
      parameter.nil? == false && parameter.empty? == false
    end
    
    def encode(path_parameter)
      URI::encode(path_parameter)
    end
  
  end
  
  class AddressError < StandardError; end
  
  class AreaError < StandardError; end
  
  class ServiceError < StandardError; end
  
  class GeocodeError < StandardError; end

end