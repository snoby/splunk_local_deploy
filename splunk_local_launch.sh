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
rm -rf /tmp/save/*

mkdir -p /tmp/save/{etc,var}

docker stop splunk
docker rm splunk
  # -v $PWD/license/License.xml:/tmp/License.xml:ro         \
  #-v /tmp/save/etc:/opt/splunk/etc                        \
  #-v /tmp/save/var:/opt/splunk/var                        \
  #-e SPLUNK_LICENSE_URI=/tmp/License.xml                  \
  #-e SPLUNK_LAUNCH_CONF=OPTIMISTIC_ABOUT_FILE_LOCKING=1   \

docker run -d                                             \
  -p 8000:8000                                            \
  -p 8088:8088                                            \
  -p 8089:8089                                            \
  -e 'SPLUNK_START_ARGS=--accept-license'                 \
  -e 'SPLUNK_PASSWORD=password123'                        \
  -v $PWD/license/License.xml:/tmp/License.xml:ro         \
  -v $PWD/default.yml/:/tmp/defaults/default.yml:ro         \
  --name=splunk                                           \
  splunk/splunk:latest


echo "Need to wait for the splunk service to be available...."
