#!/bin/sh

# Create region

echo "Create region: RegionOne"
curl --silent -X POST \
  http://{{ .Values.service.name }}:{{ .Values.service.internalPort }}/api/dcim/regions/ \
  -H 'Authorization: Token onceuponatimeiplayedwithnetbox20180814' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "RegionOne",
  "slug": "RegionOne"
}'

# Create tenant group

echo "Create tenant group: ONAP group"
curl --silent -X POST \
  http://{{ .Values.service.name }}:{{ .Values.service.internalPort }}/api/tenancy/tenant-groups/ \
  -H 'Authorization: Token onceuponatimeiplayedwithnetbox20180814' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "ONAP group",
  "slug": "onap-group"
}'

# Create tenant

echo "Create tenant ONAP in ONAP group"
curl --silent -X POST \
  http://{{ .Values.service.name }}:{{ .Values.service.internalPort }}/api/tenancy/tenants/ \
  -H 'Authorization: Token onceuponatimeiplayedwithnetbox20180814' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "ONAP",
  "slug": "onap",
  "group": 1,
  "description": "ONAP tenant",
  "comments": "Tenant for ONAP demo use cases"
}'

# Create site

echo "Create ONAP demo site: Montreal Lab"
curl --silent -X POST \
  http://{{ .Values.service.name }}:{{ .Values.service.internalPort }}/api/dcim/sites/ \
  -H 'Authorization: Token onceuponatimeiplayedwithnetbox20180814' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Montreal Lab D3",
  "slug": "mtl-lab-d3",
  "region": 1,
  "tenant": 1,
  "facility": "Campus",
  "time_zone": "Canada/Atlantic",
  "description": "Site hosting the ONAP use cases",
  "physical_address": "1 Graham Bell",
  "shipping_address": "1 Graham Bell",
  "contact_name": "Alexis",
  "contact_phone": "0000000000",
  "contact_email": "adetalhouet89@gmail.com",
  "comments": "ONAP lab"
}'

# Create prefixes

echo "Create Prefix for vFW protected network"
curl --silent -X POST \
  http://{{ .Values.service.name }}:{{ .Values.service.internalPort }}/api/ipam/prefixes/ \
  -H 'Authorization: Token onceuponatimeiplayedwithnetbox20180814' \
  -H 'Content-Type: application/json' \
  -d '{
  "prefix": "{{ .Values.service.private2 }}",
  "site": 1,
  "tenant": 1,
  "is_pool": false,
  "description": "IP Pool for private network 2"
}'

echo "Create Prefix for vFW unprotected network"
curl --silent -X POST \
  http://{{ .Values.service.name }}:{{ .Values.service.internalPort }}/api/ipam/prefixes/ \
  -H 'Authorization: Token onceuponatimeiplayedwithnetbox20180814' \
  -H 'Content-Type: application/json' \
  -d '{
  "prefix": "{{ .Values.service.private1 }}",
  "site": 1,
  "tenant": 1,
  "is_pool": false,
  "description": "IP Pool for private network 1"
}'

echo "Create Prefix for ONAP general purpose network"
curl --silent -X POST \
  http://{{ .Values.service.name }}:{{ .Values.service.internalPort }}/api/ipam/prefixes/ \
  -H 'Authorization: Token onceuponatimeiplayedwithnetbox20180814' \
  -H 'Content-Type: application/json' \
  -d '{
  "prefix": "{{ .Values.service.management }}",
  "site": 1,
  "tenant": 1,
  "is_pool": false,
  "description": "IP Pool for ONAP - general purpose"
}'

# Reserve ports, gateway and dhcp, for each protected and unprotected networks.

curl --silent -X  POST \
  http://{{ .Values.service.name }}:{{ .Values.service.internalPort }}/api/ipam/prefixes/1/available-ips/ \
  -H 'Authorization: Token onceuponatimeiplayedwithnetbox20180814' \
  -H 'Content-Type: application/json'

curl --silent -X  POST \
  http://{{ .Values.service.name }}:{{ .Values.service.internalPort }}/api/ipam/prefixes/1/available-ips/ \
  -H 'Authorization: Token onceuponatimeiplayedwithnetbox20180814' \
  -H 'Content-Type: application/json'

curl --silent -X  POST \
  http://{{ .Values.service.name }}:{{ .Values.service.internalPort }}/api/ipam/prefixes/2/available-ips/ \
  -H 'Authorization: Token onceuponatimeiplayedwithnetbox20180814' \
  -H 'Content-Type: application/json'

curl --silent -X  POST \
  http://{{ .Values.service.name }}:{{ .Values.service.internalPort }}/api/ipam/prefixes/2/available-ips/ \
  -H 'Authorization: Token onceuponatimeiplayedwithnetbox20180814' \
  -H 'Content-Type: application/json'

curl --silent -X  POST \
  http://{{ .Values.service.name }}:{{ .Values.service.internalPort }}/api/ipam/prefixes/3/available-ips/ \
  -H 'Authorization: Token onceuponatimeiplayedwithnetbox20180814' \
  -H 'Content-Type: application/json'

curl --silent -X  POST \
  http://{{ .Values.service.name }}:{{ .Values.service.internalPort }}/api/ipam/prefixes/3/available-ips/ \
  -H 'Authorization: Token onceuponatimeiplayedwithnetbox20180814' \
  -H 'Content-Type: application/json'
