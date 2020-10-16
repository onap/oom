#!/bin/bash
{{/*
#
# ============LICENSE_START==========================================
# org.onap.music
# ===================================================================
#  Copyright (c) 2019 AT&T Intellectual Property
# ===================================================================
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
# ============LICENSE_END=============================================
# ====================================================================
*/}}

echo "Running startup script to get password from certman"
PWFILE=/opt/app/aafcertman/.password
LOGFILE=/opt/app/music/logs/MUSIC/music-sb.log
PROPS=/opt/app/music/etc/music-sb.properties
LOGBACK=/opt/app/music/etc/logback.xml
LOGGING=
DEBUG_PROP=
# Debug Setup. Uses env variables
# DEBUG and DEBUG_PORT
# DEBUG=true/false | DEBUG_PORT=<Port valie must be integer>
if [ "${DEBUG}" == "true" ]; then
  if [ "${DEBUG_PORT}" == "" ]; then
    DEBUG_PORT=8000
  fi
  echo "Debug mode on"
  DEBUG_PROP="-Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=${DEBUG_PORT},suspend=n"
fi

# LOGBACK file: if /opt/app/music/etc/logback.xml exists thenuse that.
if [ -f $LOGBACK ]; then
  LOGGING="--logging.config=file:${LOGBACK}"
fi

# Get Passwords from /opt/app/aafcertman
if [ -f $PWFILE ]; then
  echo "Found ${PWFILE}" >> $LOGFILE
  PASSWORD=$(cat ${PWFILE})
else
  PASSWORD=changeit
  echo "#### Using Default Password for Certs" >> ${LOGFILE}
fi

# If music-sb.properties exists in /opt/app/music/etc then use that to override the application.properties
if [ -f $PROPS ]; then
  # Run with different Property file
  #echo "java ${DEBUG_PROP} -jar MUSIC.jar --spring.config.location=file:${PROPS} ${LOGGING} 2>&1 | tee ${LOGFILE}"
  java ${DEBUG_PROP} ${JAVA_OPTS} -jar MUSIC-SB.jar ${SPRING_OPTS} --spring.config.location=file:${PROPS} ${LOGGING} 2>&1 | tee ${LOGFILE}
else
  #echo "java ${DEBUG_PROP} -jar MUSIC.jar --server.ssl.key-store-password=${PASSWORD} ${LOGGING} 2>&1 | tee ${LOGFILE}"
  java ${DEBUG_PROP} ${JAVA_OPTS} -jar MUSIC-SB.jar ${SPRING_OPTS} --server.ssl.key-store-password="${PASSWORD}" ${LOGGING} 2>&1 | tee ${LOGFILE}
fi




