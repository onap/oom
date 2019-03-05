#!/bin/sh

/usr/share/elasticsearch/plugins/search-guard-6/tools/sgadmin.sh \
  -cd /usr/share/elasticsearch/config/sg \
  -ks /usr/share/elasticsearch/config/sg/auth/{{ .Values.config.adminKeyStore }} \
  -ts /usr/share/elasticsearch/config/sg/auth/{{ .Values.config.trustStore }} \
  -kspass {{ .Values.config.adminKeyStorePassword }} \
  -tspass {{ .Values.config.trustStorePassword}} \
  -nhnv \
  -icl \
  -p {{ .Values.service.internalPort2 }}