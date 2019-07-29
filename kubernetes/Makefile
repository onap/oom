# Copyright © 2017 Amdocs, Bell Canada
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

PARENT_CHART := onap
COMMON_CHARTS_DIR := common
# FIXME OOM-765
ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
OUTPUT_DIR := $(ROOT_DIR)/dist
PACKAGE_DIR := $(OUTPUT_DIR)/packages
SECRET_DIR := $(OUTPUT_DIR)/secrets

EXCLUDES := config oneclick readiness test dist helm $(PARENT_CHART) dcae
HELM_CHARTS := $(filter-out $(EXCLUDES), $(patsubst %/.,%,$(wildcard */.))) $(PARENT_CHART)
EXCLUSIONS_FOR_SCHEMA_CHECK := uui sniro-emulator vid so common dmaap cli aaf log esr pomba modeling consul dcaegen2 vnfsdk cds policy multicloud contrib clamp appc sdc portal aai oof nbi robot msb vfc pnda sdnc onap
ALL_CHARTS := $(filter-out $(EXCLUSIONS_FOR_SCHEMA_CHECK), $(HELM_CHARTS))  
.PHONY: $(EXCLUDES) $(HELM_CHARTS)

all: $(COMMON_CHARTS_DIR) $(HELM_CHARTS) plugins

$(COMMON_CHARTS):
	@echo "\n[$@]"
	@make package-$@

$(HELM_CHARTS):
	@echo "\n[$@]"
	@make package-$@

make-%:
	@if [ -f $*/Makefile ]; then make -C $*; fi

dep-%: make-%
	@if [ -f $*/requirements.yaml ]; then helm dep up $*; fi

lint-%: dep-%
	@if [ -f $*/Chart.yaml ]; then helm lint $*; fi

schema-%: lint-%
	@if [ -f $*/values.yaml ]; then python $(ROOT_DIR)/validateSchema.py $*/values.yaml $* "-d"; fi
	@for sub_charts in $*/charts/*; \
	do \
		if [ -f $${sub_charts}/values.yaml ]; then \
			python $(ROOT_DIR)/validateSchema.py $${sub_charts}/values.yaml $${sub_charts} "-d"; \
		fi; \
	done	
		

package-%: schema-%
	@mkdir -p $(PACKAGE_DIR)
	@if [ -f $*/Chart.yaml ]; then helm package -d $(PACKAGE_DIR) $*; fi
	@helm repo index $(PACKAGE_DIR)

checkSchema:  
	@for charts in $(ALL_CHARTS); \
        do \
		if [ $${charts} = common ]; then \
			  $(MAKE) -C common checkSchema; \
		fi; \
		if [ -f $${charts}/values.yaml ]; then \
                        python $(ROOT_DIR)/validateSchema.py $${charts}/values.yaml $${charts} "-v"; \
                fi; \
	 	for sub_charts in $${charts}/charts/*; \
        	do \
                	if [ -f $${sub_charts}/values.yaml ]; then \
                        	python $(ROOT_DIR)/validateSchema.py $${sub_charts}/values.yaml $${sub_charts} "-v"; \
                	fi; \
        	done;\
        done

install:
	@pip install -r $(ROOT_DIR)/requirements.txt


clean:
	@rm -f */requirements.lock
	@find . -type f -name '*.tgz' -delete
	@rm -rf $(PACKAGE_DIR)/*

# publish helm plugins via distrubtion directory
plugins:
	@cp -R helm $(PACKAGE_DIR)/

# start up a local helm repo to serve up helm chart packages
repo:
	@mkdir -p $(PACKAGE_DIR)
	@helm serve --repo-path $(PACKAGE_DIR) &
	@helm repo index $(PACKAGE_DIR)
	@helm repo add local http://127.0.0.1:8879

# stop local helm repo
repo-stop:
	@pkill helm
	@helm repo remove local
%:
	@:
