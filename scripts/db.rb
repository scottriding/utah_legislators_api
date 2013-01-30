require 'rubygems'
require 'sequel'
require 'trollop'
require_relative '../settings'

Sequel.extension :migration

def db_load
  Sequel::Migrator.apply(SETTINGS[:db], 'scripts/migrations')
  puts 'Data tables successfully loaded.'
end

def db_drop
  Sequel::Migrator.apply(SETTINGS[:db], 'scripts/migrations', 0)
  puts 'Data tables successfully dropped.'
end

opts = Trollop::options do
  opt :load, "Load data tables into the database", :default => true
  opt :drop, "Drop data tables from the database"
end

if opts[:drop]
  db_drop
else
  db_load
end





