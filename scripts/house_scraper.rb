require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'trollop'

### Class definitions ###

class HouseRosterScraper

  HOUSE_URL_STUB = 'http://le.utah.gov/house2/'
  ROSTER_URL_DETAIL = 'representatives.jsp'
  
  def self.scrape
    page = self.retrieve_page()
    html = self.parse_html(page)
    self.extract_roster(html)
  end
  
  def self.retrieve_page
    open("#{HOUSE_URL_STUB}#{ROSTER_URL_DETAIL}").read()
  end
  
  def self.parse_html(page)
    Nokogiri::HTML(page)
  end
  
  def self.extract_roster(html)
    html.css('tr:not(:first-child)').collect do |row|
      representative = {}
      row.css('td').each_with_index do |column, index|
        case index
        when 0
          representative['district'] = column.content()
        when 1
          representative['name'] = column.content()
          url_detail = column.at_css('a')['href']
          representative['official_url'] = "#{HOUSE_URL_STUB}#{url_detail}"
          representative['legislative_id'] = url_detail.split('=')[1]
        when 2
          representative['party'] = column.content()
        end
      end
      representative['chamber'] = 'House of Representatives'
      representative
    end
  end
end

class HouseMemberScraper
                
  UTAH_GOV_STUB = "http://le.utah.gov"
  LEADERSHIP_REGEX = /<em>(.+)<\/em>/
  ADDRESS_REGEX = /<b>Address:<\/b> (.+)<br>/
  EMAIL_REGEX = /<b>Email:<\/b> <a href="mailto:(.+)"/
  CELL_PHONE_REGEX = /<b>Cell Phone:<\/b> (.+)<br>/
  WORK_PHONE_REGEX = /<b>Work Phone:<\/b> (.+)<br>/
  HOME_PHONE_REGEX = /<b>Home Phone:<\/b> (.+)<br>/
  EDUCATION_REGEX = /<b>Education:<\/b> (.+)<br>/
  PROFESSION_REGEX = /<b>Profession:<\/b> (.+)<br>/
  LEGISLATOR_SINCE_REGEX = /<b>Legislative Service Since:<\/b> (.+)\r\n/

  def initialize(data)
    @name = data['name']
    @party = data['party']
    @district = data['district']
    @official_url = data['official_url']
    @chamber = data['chamber']
    @legislative_id = data['legislative_id']
    page = retrieve_page(data['official_url'])
    html = parse_html(page)
    profile = html.css('#profile').inner_html()
    @leadership = scrape_leadership(profile)
    @contact = scrape_contact(profile)
    @bio = scrape_bio(html)
    @committees = scrape_committees(html)
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
  
  def retrieve_page(url)
    open(url).read()
  end
  
  def parse_html(page)
    Nokogiri::HTML(page)
  end
  
  def scrape_leadership(page)
    scrape_regex(LEADERSHIP_REGEX, page)
  end
  
  def scrape_contact(page)
    contact = {}
    contact['address'] = scrape_address(page)
    contact['email'] = scrape_email(page)
    contact['phones'] = scrape_phones(page)
    contact
  end
  
  def scrape_address(page)
    scrape_regex(ADDRESS_REGEX, page)
  end
  
  def scrape_email(page)
    scrape_regex(EMAIL_REGEX, page)
  end
  
  def scrape_phones(page)
    phones = {}
    phones['home_phone'] = scrape_regex(HOME_PHONE_REGEX, page)
    phones['work_phone'] = scrape_regex(WORK_PHONE_REGEX, page)
    phones['cell_phone'] = scrape_regex(CELL_PHONE_REGEX, page)
    phones.delete_if { |k, v| v.nil? } # Purge any nil entries
    phones
  end
  
  def scrape_bio(html)
    page = html.inner_html()
    bio = {}
    bio['legislator_since'] = scrape_legislator_since(page)
    bio['education'] = scrape_education(page)
    bio['profession'] = scrape_profession(page)
    bio['photo_url'] = scrape_photo_url(html)
    bio
  end
  
  def scrape_legislator_since(page)
    scrape_regex(LEGISLATOR_SINCE_REGEX, page)
  end
  
  def scrape_education(page)
    scrape_regex(EDUCATION_REGEX, page)
  end
  
  def scrape_profession(page)
    scrape_regex(PROFESSION_REGEX, page)
  end
  
  def scrape_photo_url(html)
    photo_html = html.at_css('img[alt=photo]')
    "#{UTAH_GOV_STUB}#{photo_html['src']}"
  end
  
  def scrape_committees(html)
    committees_html = html.css('#profile ul li a')
    committees_html.collect do |committee_html|
      {
        committee_name: committee_html.content(),
        committee_url: "#{UTAH_GOV_STUB}#{committee_html['href']}",
        committee_id: committee_html['href'].split('=')[1]
      }
    end
  end
  
  def scrape_regex(regex, page)
    matches = regex.match(page)
    if matches
      matches[1]
    else
      nil
    end
  end

end

### Main script ###

def scrape(output_file)
  puts "Scraping House Roster..."
  roster = HouseRosterScraper.scrape()
  puts "...done!"
  house_members = roster.collect do |representative|
    puts "Scraping #{representative['name']} details..."
    house_member = HouseMemberScraper.new(representative)
    puts "...done!"
    house_member.to_hash()
  end
  puts "Saving to #{output_file}..."
  File.open(output_file, 'w') do |file|
    file << house_members.to_json()
  end
  puts "...done!"
end

opts = Trollop::options do
  opt :output, "Specify location to save JSON", :default => "#{File.dirname(__FILE__)}/data/representatives.json"
end

scrape(opts[:output])



