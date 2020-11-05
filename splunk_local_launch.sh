#!/bin/bash
set +x

#
# GLOBAL VALUES
#

#
# Helper functions
#




#
# MAIN
#
# Clean out existing  saved defaults.

docker stop splunk
docker rm splunk
  # -v $PWD/license/License.xml:/tmp/License.xml:ro         \
  #-e SPLUNK_LICENSE_URI=/tmp/License.xml                  \
  #-e SPLUNK_LAUNCH_CONF=OPTIMISTIC_ABOUT_FILE_LOCKING=1   \

docker run -d                                                       \
  -p 8000:8000                                                      \
  -p 8088:8088                                                      \
  -p 8089:8089                                                      \
  -e 'SPLUNK_START_ARGS=--accept-license'                           \
  -e 'SPLUNK_PASSWORD=password123'                                  \
  -e 'SPLUNK_APPS_URL=/tmp/lma.tgz,/tmp/splunk_httpinput.tgz'       \
  -e SPLUNK_LICENSE_URI=/tmp/License.xml                            \
  -v $PWD/license/License.xml:/tmp/License.xml:ro                   \
  -v $PWD/configs/lma.tgz:/tmp/lma.tgz:ro                           \
  -v $PWD/configs/splunk_httpinput.tgz:/tmp/splunk_httpinput.tgz:ro \
  -v $PWD/configs/default.yml/:/tmp/defaults/default.yml:ro         \
  --name=splunk                                                     \
  --hostname=splunk                                                 \
  --memory=4g                                                       \
  splunk/splunk:8.1



  #splunk/splunk:8.0.4-debian


echo "Need to wait for the splunk service to be available.... check with 'docker logs -f splunk' "
