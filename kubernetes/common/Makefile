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

# FIXME OOM-765
ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
OUTPUT_DIR := $(ROOT_DIR)/../dist
PACKAGE_DIR := $(OUTPUT_DIR)/packages
SECRET_DIR := $(OUTPUT_DIR)/secrets
COMMON_CHARTS_DIR := common

EXCLUDES :=
HELM_CHARTS := $(filter-out $(EXCLUDES), $(patsubst %/.,%,$(wildcard */.)))
PARENT_DIR := $(shell dirname $(ROOT_DIR))
.PHONY: $(EXCLUDES) $(HELM_CHARTS)

all: $(COMMON_CHARTS_DIR) $(HELM_CHARTS)

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
	@if [ -f $*/values.yaml ]; then python $(PARENT_DIR)/validateSchema.py $*/values.yaml $* "-d"; fi
	@for sub_chart in $*/charts/*; \
	do \
		if [ -f $${sub_chart}/values.yaml ]; then \
			python $(PARENT_DIR)/validateSchema.py $${sub_chart}/values.yaml $${sub_chart} "-d"; \
		fi; \
	done

package-%: schema-%
	@mkdir -p $(PACKAGE_DIR)
	@if [ -f $*/Chart.yaml ]; then helm package -d $(PACKAGE_DIR) $*; fi
	@helm repo index $(PACKAGE_DIR)

checkSchema:  
	@for charts in $(HELM_CHARTS); \
        do \
                if [ -f $${charts}/values.yaml ]; then \
                        python $(PARENT_DIR)/validateSchema.py $${charts}/values.yaml $${charts} "-v"; \
                fi; \
	 	for sub_charts in $${charts}/charts/*; \
        	do \
                	if [ -f $${sub_charts}/values.yaml ]; then \
                        	python $(PARENT_DIR)/validateSchema.py $${sub_charts}/values.yaml $${sub_charts} "-v"; \
                	fi; \
        	done;\
        done

clean:
	@rm -f */requirements.lock
	@rm -f *tgz */charts/*tgz
	@rm -rf $(PACKAGE_DIR)
%:
	@:
