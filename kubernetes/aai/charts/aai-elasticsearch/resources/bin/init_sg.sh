#!/bin/sh

/usr/share/elasticsearch/plugins/search-guard-6/tools/sgadmin.sh \
  -cd /usr/share/elasticsearch/config/sg \
  -ks /usr/share/elasticsearch/config/sg/auth/sgadmin-keystore.p12 \
  -ts /usr/share/elasticsearch/config/sg/auth/truststore.jks \
  -kspass {{ .Values.config.adminKeyStorePassword }} \
  -tspass {{ .Values.config.trustStorePassword}} \
  -nhnv \
  -icl \
  -p {{ .Values.service.internalPort2 }}