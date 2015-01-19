A simple API for Utah state legislator data
============================================

Installation
------------

The API is built in Ruby on the excellent Sinatra framework and uses PostgreSQL with PostGIS extensions for the backend.

This guides assumes you have [rbenv](https://github.com/sstephenson/rbenv) installed.

Clone the repository to your server then run...

_rbenv install_

_bundle install_

...to install the right version of Ruby and library dependencies.

Then there are a number of environmental variables you need to set to ensure the API points to the right places:

_AGRC_API_KEY_: Sign up for a key with the [Utah AGRC](https://developer.mapserv.utah.gov/secure/KeyManagement). This excellent service handles the geocoding.
_AGRC_GEOCODER_ENDPOINT_: Currently, this should be set to http://api.mapserv.utah.gov/api/v1/geocode
_AGRC_REFERER_URL_: Set this to the URL where you will be hosting the API
_DATABASE_URL_: Set this to the postgresql:// URL where the database is located (must have read/write permission)

Once those are set in the environment, run...

_bundle exec ruby scripts/db.rb_

...which will load the data into your chosen PostgreSQL instance (installing PostGIS if it is not already installed).

Then run...

_rackup_

...to start the API.

There are a couple of other useful scripts. If you need to update legislator data, run...

_bundle exec ruby scripts/house_scraper.rb_
_bundle exec ruby scripts/senate_scraper.rb_

...which will update the JSON in the /data folder. Then you'll need to run...

_bundle exec ruby scripts/db.rb --drop_
_bundle exec ruby scripts/db.rb --load_

...to rebuild the database with the new data.

Usage
-----

It's JSON all the way down. JSONP is supported -- just add a callback parameter.

**Who is the senator in district 14?**

_GET http://api.utlegislators.com/senate/14?api_key=testing_

```javascript
{
  "name": "Jackson, Alvin B.",
  "party": "R",
  "district": "14",
  "official_url": "http:\/\/www.utahsenate.org\/aspx\/senmember.aspx?dist=14",
  "chamber": "Senate",
  "legislative_id": "JACKSAB",
  "leadership": null,
  "contact": {
    "address": "6108 NEW LONDON STREET HIGHLAND, UT 84003",
    "email": "abjackson@le.utah.gov",
    "phones": {
      "home_phone": "801-216-4479",
      "work_phone": "801-899-5447",
      "fax_phone": "801-216-4589"
    }
  },
  "bio": {
    "legislator_since": "Appointed 2014",
    "education": "B.S., Business Administration, Embry-Riddle University\\nM.B.A., Johns Hopkins University",
    "profession": "Small Business Owner\\nBusiness Consulting",
    "photo_url": "http:\/\/www.utahsenate.org\/images\/member-photos\/JACKSAB.jpg"
  },
  "committees": [
    {
      "committee_name": "Social Services Appropriations Subcommittee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=APPSOC",
      "committee_id": "APPSOC"
    },
    {
      "committee_name": "Senate Government Operations and Political Subdivisions Committee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=SSTGOP",
      "committee_id": "SSTGOP"
    },
    {
      "committee_name": "Senate Transportation and Public Utilities and Technology Committee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=SSTTPT",
      "committee_id": "SSTTPT"
    },
    {
      "committee_name": "Federal Funds Commission",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=SPEFFC",
      "committee_id": "SPEFFC"
    },
    {
      "committee_name": "Senate Government Operations Confirmation Committee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=SPEGOV",
      "committee_id": "SPEGOV"
    },
    {
      "committee_name": "Senate Transportation and Public Utilities and Technology Confirmation Committee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=SPETRA",
      "committee_id": "SPETRA"
    }
  ]
}
```

**Who is the house representative in district 72?**

_GET http://api.utlegislators.com/house/72?api_key=testing_

```javascript
{
  "name": "Westwood, John R.",
  "party": "R",
  "district": "72",
  "official_url": "http:\/\/le.utah.gov\/house2\/detail.jsp?i=WESTWJR",
  "chamber": "House of Representatives",
  "legislative_id": "WESTWJR",
  "leadership": null,
  "contact": {
    "address": "751 S 2075 W CEDAR CITY, UT 84720",
    "email": "jwestwood@le.utah.gov",
    "phones": {
      "home_phone": "435-586-6961",
      "work_phone": "435-865-2318"
    }
  },
  "bio": {
    "legislator_since": "January 1, 2013",
    "education": "B.S., Business Administration, Southern Utah University; Post Graduate, Pacific Coast Banking School, University of Washington",
    "profession": "Banker",
    "photo_url": "http:\/\/le.utah.gov\/images\/legislator\/westwjr.jpg"
  },
  "committees": [
    {
      "committee_name": "Business, Economic Development, and Labor Appropriations Subcommittee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Com=APPBEL",
      "committee_id": "APPBEL"
    },
    {
      "committee_name": "House Economic Development and Workforce Services Committee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Com=HSTEDW",
      "committee_id": "HSTEDW"
    },
    {
      "committee_name": "House Retirement and Independent Entities Committee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Com=HSTRIE",
      "committee_id": "HSTRIE"
    },
    {
      "committee_name": "House Transportation Committee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Com=HSTTRA",
      "committee_id": "HSTTRA"
    },
    {
      "committee_name": "Public Utilities and Technology Interim Committee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Com=INTPUT",
      "committee_id": "INTPUT"
    },
    {
      "committee_name": "Retirement and Independent Entities Appropriations Subcommittee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Com=APPRIE",
      "committee_id": "APPRIE"
    },
    {
      "committee_name": "Revenue and Taxation Interim Committee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Com=INTREV",
      "committee_id": "INTREV"
    }
  ]
}
```

**Give me a list of all the state senators.**

_GET http://api.utlegislators.com/senate?api_key=testing_

**Who represents me in the legislature?**

This call requires two parameters:

1. address -- a house number and street name
2. area -- either a city name or a 5-digit zipcode

Geocoding is generously provided by the [Utah AGRC](http://gis.utah.gov)

_GET http://api.utlegislators.com/representation?api_key=testing&address=603%20E%20South%20Temple&area=salt%20lake%20city_

```javascript
{
  "geocoded_address": {
    "input_address": "603 E South Temple, salt lake city",
    "match_address": "603 E SOUTH TEMPLE ST, SALT LAKE CITY",
    "latitude": 4513572.8555958,
    "longitude": 426242.36374957,
    "spatial_reference_key": 26912
  },
  "senator": {
    "name": "Dabakis, Jim",
    "party": "D",
    "district": "2",
    "official_url": "http:\/\/www.utahsenate.org\/aspx\/senmember.aspx?dist=2",
    "chamber": "Senate",
    "legislative_id": "DABAKJ",
    "leadership": "Minority Caucus Manager",
    "contact": {
      "address": "54 B STREET SALT LAKE CITY, UT 84103",
      "email": "jdabakis@le.utah.gov",
      "phones": {
        "cell_phone": "801-656-8269"
      }
    },
    "bio": {
      "legislator_since": "Appointed January 28, 2013",
      "education": "Attended Brigham Young University",
      "profession": "Art Dealer",
      "photo_url": "http:\/\/www.utahsenate.org\/images\/member-photos\/DABAKJ.jpg"
    },
    "committees": [
      {
        "committee_name": "Executive Appropriations Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=APPEXE",
        "committee_id": "APPEXE"
      },
      {
        "committee_name": "Higher Education Appropriations Subcommittee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=APPHED",
        "committee_id": "APPHED"
      },
      {
        "committee_name": "Natural Resources, Agriculture, and Environmental Quality Appropriations Subcommittee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=APPNAE",
        "committee_id": "APPNAE"
      },
      {
        "committee_name": "Senate Education Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=SSTEDU",
        "committee_id": "SSTEDU"
      },
      {
        "committee_name": "Senate Revenue and Taxation Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=SSTREV",
        "committee_id": "SSTREV"
      },
      {
        "committee_name": "Senate Rules Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=SSTRUL",
        "committee_id": "SSTRUL"
      },
      {
        "committee_name": "Government Operations Interim Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=INTGOC",
        "committee_id": "INTGOC"
      },
      {
        "committee_name": "Natural Resources, Agriculture, and Environment Interim Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=INTNAE",
        "committee_id": "INTNAE"
      },
      {
        "committee_name": "Administrative Rules Review Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=SPEADM",
        "committee_id": "SPEADM"
      },
      {
        "committee_name": "Commission for the Stewardship of Public Lands",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=SPESPL",
        "committee_id": "SPESPL"
      },
      {
        "committee_name": "Federal Funds Commission",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=SPEFFC",
        "committee_id": "SPEFFC"
      },
      {
        "committee_name": "Legislative Management Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=SPEMAN",
        "committee_id": "SPEMAN"
      },
      {
        "committee_name": "Rural Development Legislative Liaison Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=SPERDL",
        "committee_id": "SPERDL"
      },
      {
        "committee_name": "Senate Education Confirmation Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=SPEEDU",
        "committee_id": "SPEEDU"
      },
      {
        "committee_name": "Senate Judicial Confirmation Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=SPESJC",
        "committee_id": "SPESJC"
      },
      {
        "committee_name": "Senate Natural Resources, Agriculture, and Environment Confirmation Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=SPENAT",
        "committee_id": "SPENAT"
      },
      {
        "committee_name": "Senate Revenue and Taxation Confirmation Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=SPEREV",
        "committee_id": "SPEREV"
      },
      {
        "committee_name": "Utah Tax Review Commission",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2015&Com=SPETAX",
        "committee_id": "SPETAX"
      }
    ]
  },
  "representative": {
    "name": "Chavez-Houck, Rebecca",
    "party": "D",
    "district": "24",
    "official_url": "http:\/\/le.utah.gov\/house2\/detail.jsp?i=CHAVER",
    "chamber": "House of Representatives",
    "legislative_id": "CHAVER",
    "leadership": "Minority Whip",
    "contact": {
      "address": "643 16TH AVE SALT LAKE CITY, UT 84103",
      "email": "rchouck@le.utah.gov",
      "phones": {
        "cell_phone": "801-891-9292"
      }
    },
    "bio": {
      "legislator_since": "Appointed January 2, 2008",
      "education": "B.A., University of Utah; M.P.A., University of Utah",
      "profession": "Public Relations",
      "photo_url": "http:\/\/le.utah.gov\/images\/legislator\/chaver.jpg"
    },
    "committees": [
      {
        "committee_name": "Executive Appropriations Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Com=APPEXE",
        "committee_id": "APPEXE"
      },
      {
        "committee_name": "Health and Human Services Interim Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Com=INTHHS",
        "committee_id": "INTHHS"
      },
      {
        "committee_name": "Health Reform Task Force",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Com=TSKHSR",
        "committee_id": "TSKHSR"
      },
      {
        "committee_name": "House Government Operations Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Com=HSTGOC",
        "committee_id": "HSTGOC"
      },
      {
        "committee_name": "House Health and Human Services Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Com=HSTHHS",
        "committee_id": "HSTHHS"
      },
      {
        "committee_name": "House Special Investigative Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Com=SPESIC",
        "committee_id": "SPESIC"
      },
      {
        "committee_name": "Legislative Management Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Com=SPEMAN",
        "committee_id": "SPEMAN"
      },
      {
        "committee_name": "Revenue and Taxation Interim Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Com=INTREV",
        "committee_id": "INTREV"
      },
      {
        "committee_name": "Social Services Appropriations Subcommittee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Com=APPSOC",
        "committee_id": "APPSOC"
      }
    ]
  }
}
```

Credits & License
-----------------

Geocoding service & district boundaries generously provided by the [Utah AGRC](http://gis.utah.gov).

Information about legislators pulled from the [LRGC](http://le.utah.gov).

The MIT License

Copyright (c) 2015 Scott Riding

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.