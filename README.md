A simple API for learning about and connecting with Utah state legislators
==========================================================================

It's simple:

Who is the senator in district 14?
----------------------------------

http://api.utlegislators.com/senate/14?api_key=testing

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

Who is the house representative in district 72?
-----------------------------------------------

http://api.utlegislators.com/house/14?api_key=testing
```javascript
{
  "district": 14,
  "party": "R",
  "name": "Oda, Curtis",
  "official_url": "http:\/\/le.utah.gov\/house2\/detail.jsp?i=ODAC",
  "chamber": "House of Representatives",
  "leadership": null,
  "legislative_id": "ODAC",
  "bio": {
    "education": "Clearfield High School; Business Administration and Economics, Utah State University; Business Management and Economics, Weber State College",
    "profession": "Property\/Casualty Insurance Agent",
    "legislator_since": "January 1, 2005",
    "photo_url": "http:\/\/le.utah.gov\/images\/legislator\/odac.jpg"
  },
  "contact": {
    "address": "PO BOX 824 CLEARFIELD, UT 84089",
    "email": "coda@le.utah.gov",
    "phones": {
      "home_phone": "801-773-9796",
      "cell_phone": "801-725-0277"
    }
  },
  "committees": [
    {
      "committee_name": "Administrative Rules Review Committee",
      "committee_url": "http:\/\/le.utah.gov\/house2\/\/asp\/interim\/Commit.asp?Com=SPEADM"
    },
    {
      "committee_name": "Executive Offices and Criminal Justice Appropriations Subcommittee",
      "committee_url": "http:\/\/le.utah.gov\/house2\/\/asp\/interim\/Commit.asp?Com=APPEOC"
    },
    {
      "committee_name": "House Economic Development and Workforce Services Committee",
      "committee_url": "http:\/\/le.utah.gov\/house2\/\/asp\/interim\/Commit.asp?Com=HSTEDW"
    },
    {
      "committee_name": "House Law Enforcement and Criminal Justice Committee",
      "committee_url": "http:\/\/le.utah.gov\/house2\/\/asp\/interim\/Commit.asp?Com=HSTLAW"
    },
    {
      "committee_name": "House Rules Committee",
      "committee_url": "http:\/\/le.utah.gov\/house2\/\/asp\/interim\/Commit.asp?Com=HSTRUL"
    }
  ]
}
```