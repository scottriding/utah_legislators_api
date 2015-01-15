require 'rubygems'
require 'sequel'
require 'json'
require_relative '../../settings'

Sequel.migration do
  
  up do
    # Load Utah Senate
    create_table(:senators) do
      primary_key :district
      String :data
    end
    
    senators = SETTINGS[:db][:senators]
    senate_data = JSON.parse(File.open('scripts/data/senators.json', 'r').read)
    senate_data.each do |sd|
      senators.insert(:district => sd['district'], :data => sd.to_json)
    end
    
    # Load Utah House of Representatives
    create_table(:representatives) do
      primary_key :district
      String :data
    end
    
    representatives = SETTINGS[:db][:representatives]
    house_data = JSON.parse(File.open('scripts/data/representatives.json', 'r').read)
    house_data.each do |hd|
      representatives.insert(:district => hd['district'], :data => hd.to_json)
    end
    
    # Load Utah Districts PostGIS data
    # Install the PostGIS extension
    run 'CREATE EXTENSION IF NOT EXISTS postgis'
    gis_data_sql = File.open('scripts/data/legislative_districts.sql', 'r').read
    SETTINGS[:db] << gis_data_sql
  end
  
  down do
    drop_table(:senators)
    drop_table(:representatives)
    drop_table(:house_districts)
    drop_table(:senate_districts)
  end
  
end