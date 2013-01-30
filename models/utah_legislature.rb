require 'rubygems'
require 'sequel'
require 'json'
require './utah_address'

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
      puts districts.inspect
      senator = UtahLegislature::Senator.by_district(districts[0])
      representative = UtahLegislature::Representative.by_district(districts[1])
      to_hash(address, senator, representative)
    end
    
    private
    
    def self.geocode(address, area)
      UtahAddress.geocode(address, area)
    end
    
    def self.find_districts(address)
      senate_lookup = chamber_lookup(:senate, address)
      house_lookup = chamber_lookup(:house, address)
    
      # Run the two queries simultaneously for speed
      districts = senate_lookup.union(house_lookup).all
      
      districts.collect do |d|
        d[:district]
      end
    end
    
    def self.chamber_lookup(chamber, geocodes)
      SETTINGS[:db][chamber_to_table(chamber)].select(:district).where(
        [
          "ST_Contains(
            boundaries, 
            ST_GeometryFromText('POINT(? ?)', #{SETTINGS[:spatial_ref]})
           )",
          geocodes[:longitude],
          geocodes[:latitude]
        ]
      )
    end
  
    def self.chamber_to_table(chamber)
      chamber_str = chamber.to_s
      chamber_table = "#{chamber_str}_districts".to_sym
    end
    
    def self.to_hash(address, senator, representative)
      representation = {
        :address => address,
        :senator => senator,
        :representative => representative
      }
    end
  
  end

end