# Splunk\_local\_deploy
When you don't want to break production...




- [Splunk\_local\_deploy](#splunk--local--deploy)
  * [Instructions TLDR;](#instructions-tldr-)
- [Reason for project's creation](#reason-for-project-s-creation)
  * [Implementation](#implementation)
  * [Indexes](#indexes)
    + [sourcetype](#sourcetype)
    + [HEC Tokens](#hec-tokens)
- [Making changes](#making-changes)


## Instructions TLDR;
1.) Run the splunk\_local\_launch.sh script file - this runs a docker container that is ephemeral.

2.) run `docker logs -f splunk` until the ansible script completes.  Or you could just wait until the web interface is up.

3.) log on to http://localhost:8000 username:admin password:password123

4.) run the script `quicktest.sh` ( **you may need to adjust the timestamp in the data packet**)

5.) search in the teams index for the data packet that you sent.





# Reason for project's creation
Sometimes you need an ephemeral splunk install to test data ingestion, butyou need some default values loaded.  Default values such as:

* preconfigured indexes and sourcetypes
* pre allocated HEC tokens where the token value is known ahead of time.


## Implementation

Leveraging splunk's official docker container and using the tools provided by the official splunk Ansible implementation.

https://github.com/splunk/docker-splunk

https://github.com/splunk/splunk-ansible


The docker file links to two preconfigured apps located in the configs directory ( lma.tgz and splunk_httpinput.tgz).  There is also a generated default.yml file. Which is used to enable the global HEC token and to turn off SSL for HEC.




## Indexes
We setup the predefined indexes by creating a basic app (lma) and defining the indexes in the file 

lma/local/indexes.conf  as an example

```
cat temp/lma/local/indexes.conf
[analyzer_results]
coldPath = $SPLUNK_DB/analyzer_results/colddb
homePath = $SPLUNK_DB/analyzer_results/db
thawedPath = $SPLUNK_DB/analyzer_results/thaweddb

[se]
coldPath = $SPLUNK_DB/se/colddb
homePath = $SPLUNK_DB/se/db
thawedPath = $SPLUNK_DB/se/thaweddb

```
### sourcetype
in this app we also defined a special sourcetype call `json_timestamp`

```
 cat temp/lma/local/props.conf
[json_logstash]
AUTO_KV_JSON = false
DATETIME_CONFIG =
INDEXED_EXTRACTIONS = json
LINE_BREAKER = ([\r\n]+)
MAX_TIMESTAMP_LOOKAHEAD = 20000
NO_BINARY_CHECK = true
TIMESTAMP_FIELDS = timestamp
TIME_FORMAT = %Y-%m-%dT%H:%M:%S.%3N-%z
TRUNCATE = 20000
category = Custom
description = Data FROM the LMA logstash pipeline ( almost all data will use this.)
disabled = false
pulldown_type = 1

```

### HEC Tokens
With that setup we needed to have some predefined HEC tokens that wouldn't change.
I was actually surpised that this worked.  I took the splunk_httpinput directory from the apps directory in a working splunk and created a tarball of it.  



# Making changes
The Makefile is there just as a helper.  

`make uncompress` will just uncompress the lma app and splunk_httpinput app into the temp directory so you can make your changes.  Once your changes have been completed...

`make compress` will properly compress the lma and splunk_httpinput apps in the temp directory and place them in the output directory.  You will then need to copy those new versions over the versions that are in the configs directory.  I did it this way to stop you from accidently overwriting anything.
