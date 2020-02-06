# SFTP - SSH secured ftp
Sesam datasource that reads preiodically files from a sftp server

[![Build Status](https://travis-ci.org/sesam-community/salesforce.svg?branch=master)](https://travis-ci.org/sesam-community/)

## Usage
This datasource consist of a SFTP client that periodically downloads all files from a given SFTP server/folder.
These files are then exposed via a http proxy and can then be consumed by a url pipe.
the adress will then be : http://[system._id]:[PROXY_PORT]/
Note that there are no filname conversion, so the consuming pipe must specify the correct name of the file with correct casing.
### Example system config
```
{
  "_id": "sftp-system",
  "type": "system:microservice",
  "connect_timeout": 60,
  "docker": {
    "environment": {
      "CRON_EXPRESSION": "*/5 * * * *",
      "PROXY_PORT": "5000",
      "SFT_HOST_PATH": "dumpfolder/",
      "SFT_PWD": "pwd",
      "SFT_SERVER": "sftp.test.no",
      "SFT_USER": "usr"
    },
    "image": "sesam-comunity/sesam-sftp-agent:latest",
    "memory": 64,
    "port": 5000
  },
  "read_timeout": 7200,
  "verify_ssl": false
}
```

### Example pipe config
```
{
  "_id": "sftp-system-building",
  "type": "pipe",
  "source": {
    "type": "csv",
    "system": "sftp-system",
    "delimiter": ";",
    "encoding": "utf-8",
    "has_header": true,
    "primary_key": ["BuildingId"],
    "url": "http://sftp-system:5000/Buildings.txt"
  },
  "transform": {
    "type": "dtl",
    "rules": {
      "default": [
        ["copy", "*"],
        ["add", "rdf:type",
          ["ni", "sftp-system", "building"]
        ],
        ["add", "_id",
          ["concat", "_S.BuildingId", "-", "_S.BuildingId"]
        ]
      ]
    }
  },
  "pump": {
    "cron_expression": "0 08 * * *",
    "mode": "scheduled"
  }
}
```
