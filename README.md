A simple API for Utah state legislator data
============================================

It's JSON all the way down. JSONP is supported -- just add a callback parameter.

**Who is the senator in district 14?**

_GET http://api.utlegislators.com/senate/14?api_key=testing_

```javascript
{
  "name": "Valentine, John L.",
  "district": 14,
  "party": "R",
  "official_url": "http:\/\/www.utahsenate.org\/aspx\/senmember.aspx?dist=14",
  "chamber": "Senate",
  "contact": {
    "address": "857 E 970 N OREM, UT 84097",
    "phones": {
      "home_phone": "801-224-1693",
      "work_phone": "801-373-6345",
      "fax_phone": "801-377-4991"
    },
    "email": "jvalentine@le.utah.gov"
  },
  "bio": {
    "legislator_since": "House of Representatives January 1, 1989 - November 19, 1998, Senate November 20, 1998",
    "education": "Savanna High School, Anaheim, California, B.S., Brigham Young University, J.D., J. Reuben Clark Law School, Brigham Young University",
    "profession": "Attorney",
    "photo_url": "http:\/\/www.utahsenate.org\/images\/member-photos\/VALENJL.jpg"
  },
  "committees": [
    {
      "committee_name": "Higher Education Appropriations Subcommittee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2013&Com=APPHED"
    },
    {
      "committee_name": "Natural Resources, Agriculture, and Environmental Quality Appropriations Subcommittee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2013&Com=APPNAE"
    },
    {
      "committee_name": "Senate Business and Labor Committee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2013&Com=SSTBUS"
    },
    {
      "committee_name": "Senate Revenue and Taxation Committee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2013&Com=SSTREV"
    },
    {
      "committee_name": "Senate Rules Committee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2013&Com=SSTRUL"
    },
    {
      "committee_name": "Judicial Rules Review Committee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2013&Com=SPEJRR"
    },
    {
      "committee_name": "Senate Government Operations Confirmation Committee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2013&Com=SPEGOV"
    },
    {
      "committee_name": "Senate Revenue and Taxation Confirmation Committee",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2013&Com=SPEREV"
    },
    {
      "committee_name": "Utah Constitutional Revision Commission",
      "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2013&Com=SPECRC"
    }
  ],
  "leadership": null,
  "legislative_id": "VALENJL"
}
```

**Who is the house representative in district 72?**

_GET http://api.utlegislators.com/house/72?api_key=testing_

```javascript
{
  "district": 72,
  "party": "R",
  "name": "Westwood, John R.",
  "official_url": "http:\/\/le.utah.gov\/house2\/detail.jsp?i=WESTWJR",
  "chamber": "House of Representatives",
  "leadership": null,
  "legislative_id": "WESTWJR",
  "bio": {
    "education": "B.S., Business Administration, Southern Utah University; Post Graduate, Pacific Coast Banking School, University of Washington",
    "profession": "Banker",
    "legislator_since": "January 1, 2013",
    "photo_url": "http:\/\/le.utah.gov\/images\/legislator\/westwjr.jpg"
  },
  "contact": {
    "address": "751 S 2075 W CEDAR CITY, UT 84720",
    "email": "jwestwood@le.utah.gov",
    "phones": {
      "home_phone": "435-586-6961"
    }
  },
  "committees": [
    {
      "committee_name": "House Political Subdivisions Committee",
      "committee_url": "http:\/\/le.utah.gov\/house2\/\/asp\/interim\/Commit.asp?Com=HSTPOL"
    },
    {
      "committee_name": "House Public Utilities and Technology Committee",
      "committee_url": "http:\/\/le.utah.gov\/house2\/\/asp\/interim\/Commit.asp?Com=HSTPUT"
    },
    {
      "committee_name": "Infrastructure and General Government Appropriations Subcommittee",
      "committee_url": "http:\/\/le.utah.gov\/house2\/\/asp\/interim\/Commit.asp?Com=APPIGG"
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
    "match_address": "603 E SOUTH TEMPLE ST, 84102",
    "latitude": 4513535.63,
    "longitude": 426255.72,
    "spatial_reference_key": 26912
  },
  "senator": {
    "name": "Dabakis, Jim",
    "district": 2,
    "party": "D",
    "official_url": "http:\/\/www.utahsenate.org\/aspx\/senmember.aspx?dist=2",
    "chamber": "Senate",
    "contact": {
      "address": "54 B STREET SALT LAKE CITY, UT 84103",
      "phones": {
        "cell_phone": "801-656-8269"
      },
      "email": "jdabakis@le.utah.gov"
    },
    "bio": {
      "legislator_since": "Appointed January 28, 2013",
      "education": "Attended Brigham Young University",
      "profession": "Art Dealer",
      "photo_url": "http:\/\/www.utahsenate.org\/images\/member-photos\/DABAKJ.jpg"
    },
    "committees": [
      {
        "committee_name": "Executive Offices and Criminal Justice Appropriations Subcommittee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2013&Com=APPEOC"
      },
      {
        "committee_name": "Natural Resources, Agriculture, and Environmental Quality Appropriations Subcommittee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2013&Com=APPNAE"
      },
      {
        "committee_name": "Senate Natural Resources, Agriculture, and Environment Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2013&Com=SSTNAE"
      },
      {
        "committee_name": "Senate Revenue and Taxation Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2013&Com=SSTREV"
      },
      {
        "committee_name": "Senate Natural Resources, Agriculture, and Environment Confirmation Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2013&Com=SPENAT"
      },
      {
        "committee_name": "Senate Revenue and Taxation Confirmation Committee",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2013&Com=SPEREV"
      },
      {
        "committee_name": "Utah Tax Review Commission",
        "committee_url": "http:\/\/le.utah.gov\/asp\/interim\/Commit.asp?Year=2013&Com=SPETAX"
      }
    ],
    "leadership": null,
    "legislative_id": "DABAKJ"
  },
  "representative": {
    "district": 24,
    "party": "D",
    "name": "Chavez-Houck, Rebecca",
    "official_url": "http:\/\/le.utah.gov\/house2\/detail.jsp?i=CHAVER",
    "chamber": "House of Representatives",
    "leadership": "Minority Assistant Whip",
    "legislative_id": "CHAVER",
    "bio": {
      "education": "B.A., University of Utah; M.P.A., University of Utah",
      "profession": "Public Relations",
      "legislator_since": "Appointed January 2, 2008",
      "photo_url": "http:\/\/le.utah.gov\/images\/legislator\/chaver.jpg"
    },
    "contact": {
      "address": "643 16TH AVE SALT LAKE CITY, UT 84103",
      "email": "rchouck@le.utah.gov",
      "phones": {
        "cell_phone": "801-891-9292"
      }
    },
    "committees": [
      {
        "committee_name": "Executive Appropriations Committee",
        "committee_url": "http:\/\/le.utah.gov\/house2\/\/asp\/interim\/Commit.asp?Com=APPEXE"
      },
      {
        "committee_name": "House Ethics Committee",
        "committee_url": "http:\/\/le.utah.gov\/house2\/\/asp\/interim\/Commit.asp?Com=HSTETH"
      },
      {
        "committee_name": "House Government Operations Committee",
        "committee_url": "http:\/\/le.utah.gov\/house2\/\/asp\/interim\/Commit.asp?Com=HSTGOC"
      },
      {
        "committee_name": "House Health and Human Services Committee",
        "committee_url": "http:\/\/le.utah.gov\/house2\/\/asp\/interim\/Commit.asp?Com=HSTHHS"
      },
      {
        "committee_name": "Legislative Management Committee",
        "committee_url": "http:\/\/le.utah.gov\/house2\/\/asp\/interim\/Commit.asp?Com=SPEMAN"
      },
      {
        "committee_name": "Social Services Appropriations Subcommittee",
        "committee_url": "http:\/\/le.utah.gov\/house2\/\/asp\/interim\/Commit.asp?Com=APPSOC"
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

Copyright (c) 2013 Scott Riding

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