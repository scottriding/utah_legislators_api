require 'rubygems'
require 'open-uri'
require 'json'
require 'trollop'

### Class definitions ###

class SenateRosterScraper

  LEGISLATORS_JSON = 'http://le.utah.gov/data/legislators.js'

  def self.scrape
    page = self.retrieve_page()
    json = self.parse_json(page)
    self.extract_roster(json)
  end

  def self.retrieve_page
    open(LEGISLATORS_JSON).read()
  end

  def self.parse_json(page)
    page = page.sub(/getLegislators/,'')
    page = page[1..-5] # Strip out the JS Callback
    JSON.parse(page)
  end

  def self.extract_roster(json)
    json['legislators'].select do |legislator|
      legislator['house'] == 'S'
    end
  end

end

class SenatorScraper

  def initialize(data)
    @name = data['fullName']
    @district = data['district']
    @official_url = "http://senate.utah.gov/senators/district#{@district}.html"
    @chamber = 'Senate'
    @party = data['party']
    @legislative_id = data['id']
    @leadership = data['position']
    @contact = scrape_contact(data)
    @bio = scrape_bio(data)
    @committees = scrape_committees(data)
  end

  def to_hash
    {
      name: @name,
      party: @party,
      district: @district,
      official_url: @official_url,
      chamber: @chamber,
      legislative_id: @legislative_id,
      leadership: @leadership,
      contact: @contact,
      bio: @bio,
      committees: @committees
    }
  end

  private

  def scrape_contact(data)
    contact = {}
    contact['address'] = data['address']
    contact['email'] = data['email']
    contact['phones'] = scrape_phones(data)
    contact
  end

  def scrape_phones(data)
    phones = {}
    phones['home_phone'] = data['homePhone']
    phones['work_phone'] = data['workPhone']
    phones['cell_phone'] = data['cell']
    phones['fax_phone'] = data['fax']
    phones.delete_if { |k, v| v.nil? } # Purge any nil entries
    phones
  end

  def scrape_bio(data)
    bio = {}
    bio['legislator_since'] = data['serviceStart']
    bio['education'] = data['education']
    bio['profession'] = data['profession']
    bio['photo_url'] = data['image']
    bio
  end

  def scrape_committees(data)
    data['committees'].collect do |committee|
      {
        #committee_name: committee_html.content(),
        #committee_url: committee_html['href'],
        committee_id: committee['committee']
      }
    end
  end

end

### Main script ###

def scrape(output_file)
  puts "Scraping Senate Roster..."
  roster = SenateRosterScraper.scrape()
  puts "...done!"
  senators = roster.collect do |senator|
    puts "Scraping #{senator['fullName']} details..."
    senator_detail = SenatorScraper.new(senator)
    puts "...done!"
    senator_detail.to_hash()
  end
  puts "Saving to #{output_file}..."
  File.open(output_file, 'w') do |file|
    file << senators.to_json()
  end
  puts "...done!"
end

opts = Trollop::options do
  opt :output, "Specify location to save JSON", :default => "#{File.dirname(__FILE__)}/data/senators.json"
end

scrape(opts[:output])
