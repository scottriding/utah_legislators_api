require 'rubygems'
require 'sequel'
require 'json'
require_relative 'utah_address'

module UtahLegislature

  module Legislator

    def by_district(district)
      district = district.to_i # If passed as string, convert. Else no harm no foul.
      if valid?(district)
        self[district].data
      else
        raise NonExistantDistrictError.new "District #{district} doesn't exist."
      end
    end
  
    def all_districts
      self.all.collect { |r| r.data }
    end
  
    class NonExistantDistrictError < StandardError; end
  
  end

  class Senator < Sequel::Model

    class << self
      include Legislator
    end

    plugin :serialization, :json, :data

    def self.valid?(district)
      (1..29).include?(district)
    end
  
  end

  class Representative < Sequel::Model

    class << self
      include Legislator
    end
  
    plugin :serialization, :json, :data

    def self.valid?(district)
      (1..75).include?(district)
    end

  end
  
  module Representation
  
    def self.find(address, area)
      address = geocode(address, area)
      districts = find_districts(address)
      senator = UtahLegislature::Senator.by_district(districts[:senate])
      representative = UtahLegislature::Representative.by_district(districts[:house])
      to_hash(address, senator, representative)
    end
    
    private
    
    def self.geocode(address, area)
      UtahAddress.geocode(address, area)
    end
    
    def self.find_districts(address)
      districts = chamber_lookup(address)
      format_districts_results(districts)
    end
    
    def self.chamber_lookup(geocodes)
      SETTINGS[:db].fetch(
        "SELECT district, 'senate' AS chamber
         FROM senate_districts
         WHERE
           ST_Contains(
             boundaries, 
             ST_GeometryFromText('POINT(:longitude :latitude)', :spatial_ref)
            )
         UNION
         SELECT district, 'house' AS chamber
         FROM house_districts
         WHERE
           ST_Contains(
             boundaries, 
             ST_GeometryFromText('POINT(:longitude :latitude)', :spatial_ref)
            )
         ",
        :longitude => geocodes[:longitude],
        :latitude => geocodes[:latitude],
        :spatial_ref => SETTINGS[:spatial_ref]
      ).all
    end
    
    def self.format_districts_results(districts)
      result = {}
      districts.each do |district|
        result[district[:chamber].to_sym] = district[:district]
      end
      result
    end
    
    def self.to_hash(address, senator, representative)
      representation = {
        :geocoded_address => address,
        :senator => senator,
        :representative => representative
      }
    end
  
  end

end