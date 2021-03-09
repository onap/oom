#!/bin/sh

{{/*
# Copyright © 2018  AT&T, Amdocs, Bell Canada Intellectual Property.  All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
*/}}

if curl -s -X PUT http://aai-elasticsearch:9200/searchhealth/stats/testwrite -d @/consul/scripts/aai-search-storage-write-doc.txt | grep '\"created\":true'; then
   if curl -s -X DELETE http://aai-elasticsearch:9200/searchhealth/stats/testwrite | grep '\"failed\":0'; then
      if curl -s -X GET http://aai-elasticsearch:9200/searchhealth/stats/testwrite | grep '\"found\":false'; then
         echo Successful PUT, DELETE, GET from Search Document Storage 2>&1
         exit 0
      else
         echo Failed GET from Search Document Storage 2>&1
         exit 1
      fi
   else
      echo Failed DELETE from Search Document Storage 2>&1
      exit 1
   fi
else
   echo Failed PUT from Search Document Storage 2>&1
   exit 1
fi
