require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'trollop'

### Class definitions ###

class SenateRosterScraper

  SENATE_URL_STUB = 'http://www.utahsenate.org/aspx/'
  ROSTER_URL_DETAIL = 'roster.aspx'
  
  def self.scrape
    page = self.retrieve_page()
    html = self.parse_html(page)
    self.extract_roster(html)
  end
  
  def self.retrieve_page
    open("#{SENATE_URL_STUB}#{ROSTER_URL_DETAIL}").read()
  end
  
  def self.parse_html(page)
    Nokogiri::HTML(page)
  end
  
  def self.extract_roster(html)
    html.css('tr:not(:first-child)').collect do |row|
      senator = {}
      row.css('td').each_with_index do |column, index|
        case index
        when 0
          senator['district'] = column.content()
        when 2
          senator['name'] = column.at_css('.person a').content()
          url_detail = column.at_css('.person a')['href']
          senator['official_url'] = "#{SENATE_URL_STUB}#{url_detail}"
        end
      end
      senator['chamber'] = 'Senate'
      senator
    end
  end
end

class SenatorScraper
                
  UTAH_SENATE_STUB = "http://www.utahsenate.org"
  CELL_PHONE_REGEX = /Cell\D+(\d{3}-\d{3}-\d{4})/
  WORK_PHONE_REGEX = /Work\D+(\d{3}-\d{3}-\d{4})/
  HOME_PHONE_REGEX = /Home\D+(\d{3}-\d{3}-\d{4})/
  FAX_PHONE_REGEX = /Fax\D+(\d{3}-\d{3}-\d{4})/
  PARTY_REGEX = /\(([DR])\)/

  def initialize(data)
    @name = data['name']
    @district = data['district']
    @official_url = data['official_url']
    @chamber = data['chamber']
    page = retrieve_page(data['official_url'])
    html = parse_html(page)
    profile = html.css('#main').inner_html()
    @party = scrape_party(html)
    @legislative_id = scrape_legislative_id(html)
    @leadership = scrape_leadership(html)
    @contact = scrape_contact(html)
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
  
  def scrape_party(html)
    row = html.css('tr')[1].inner_html()
    details = row.split('<br>')
    if details.length() == 4
      scrape_regex(PARTY_REGEX, details[1])
    else
      scrape_regex(PARTY_REGEX, details[0])
    end
  end
  
  def scrape_legislative_id(html)
    link = html.at_css('a:contains("View Sponsored Legislation")')['href']
    id = link.split('=')[1]
    id
  end
  
  def scrape_leadership(html)
    row = html.css('tr')[1].inner_html()
    details = row.split('<br>')
    if details.length() == 4
      details[0].sub('<td>','').strip!
    else
      nil
    end
  end
  
  def scrape_contact(html)
    sidebar = html.at_css('#sidebar')
    contact = {}
    contact['address'] = scrape_address(sidebar)
    contact['email'] = scrape_email(sidebar)
    contact['phones'] = scrape_phones(sidebar)
    contact
  end
  
  def scrape_address(html)
    tr = html.at_css('tr:contains("Address:")')
    address = ''
    tr.css('td:not(:contains("Address:"))').children().each do |el|
      address << ' ' if el.text?
      address << el.text().strip if el.text? 
    end
    address.strip
  end
  
  def scrape_email(html)
    tr = html.at_css('tr:contains("Email:")')
    email = tr.at_css('a').text()
    email.strip
  end
  
  def scrape_phones(html)
    phones = {}
    td_text = html.at_css('tr:contains("Phone:")').css('td:not(:contains("Phone:"))').text
    phones['home_phone'] = scrape_regex(HOME_PHONE_REGEX, td_text)
    phones['work_phone'] = scrape_regex(WORK_PHONE_REGEX, td_text)
    phones['cell_phone'] = scrape_regex(CELL_PHONE_REGEX, td_text)
    phones['fax_phone'] = scrape_regex(FAX_PHONE_REGEX, td_text)
    phones.delete_if { |k, v| v.nil? } # Purge any nil entries
    phones
  end
  
  def scrape_bio(html)
    bio = {}
    bio['legislator_since'] = scrape_legislator_since(html)
    bio['education'] = scrape_education(html)
    bio['profession'] = scrape_profession(html)
    bio['photo_url'] = scrape_photo_url(html)
    bio
  end
  
  def scrape_legislator_since(html)
    tr = html.at_css('tr:contains("Commenced Legislative Service:")')
    lis = tr.css('ul li')
    service = ''
    lis.children.each do |li|
      service << '\n' unless service.empty?
      service << li.text.strip if li.text?
    end
    service.strip
  end
  
  def scrape_education(html)
    tr = html.at_css('tr:contains("Education:")')
    lis = tr.css('ul li')
    education = ''
    lis.children.each do |li|
      education << '\n' unless education.empty?
      education << li.text.strip if li.text?
    end
    education.strip
  end
  
  def scrape_profession(html)
    td = html.at_css('tr td:contains("Profession"):not(:contains("Committee")):not(:contains("Professional"))')
    return '' if td.nil?
    
    lis = td.css('ul li')
    profession = ''
    lis.children.each do |li|
      profession << '\n' unless profession.empty?
      profession << li.text.strip if li.text?
    end
    profession.strip
  end
  
  def scrape_photo_url(html)
    photo_html = html.at_css('p.photo img')
    photo_url = photo_html['src']
    photo_url = "#{UTAH_SENATE_STUB}#{photo_url.split('..')[1]}"
    photo_url
  end
  
  def scrape_committees(html)
    committees_html = html.css('tr:contains("Appropriations:") ul li a')
    committees_html.collect do |committee_html|
      {
        committee_name: committee_html.content(),
        committee_url: committee_html['href'],
        committee_id: committee_html['href'].split('Com=')[1]
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
  puts "Scraping Senate Roster..."
  roster = SenateRosterScraper.scrape()
  puts "...done!"
  senators = roster.collect do |senator|
    puts "Scraping #{senator['name']} details..."
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
