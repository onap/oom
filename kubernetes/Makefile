# Copyright © 2017 Amdocs, Bell Canada
# Modification copyright (C) 2021 Nordix Foundation
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
HELM_BIN := helm

HELM_VER := $(shell $(HELM_BIN) version --template "{{.Version}}" 2>/dev/null)

# use this if you would like to cm-push onap charts to repo with other name
# WARNING: Helm v3+ only
# WARNING: Make sure to edit also Chart files
HELM_REPO := local

ifneq ($(SKIP_LINT),TRUE)
	HELM_LINT_CMD := $(HELM_BIN) lint
else
	HELM_LINT_CMD := echo "Skipping linting of"
endif

SUBMODS := robot
EXCLUDES := common config oneclick readiness test dist helm $(PARENT_CHART) dcae $(SUBMODS)
HELM_CHARTS := $(filter-out $(EXCLUDES), $(sort $(patsubst %/.,%,$(wildcard */.))))

.PHONY: $(EXCLUDES) $(HELM_CHARTS) check-for-staging-images

all: print_helm_bin $(COMMON_CHARTS_DIR) $(SUBMODS) $(HELM_CHARTS) $(PARENT_CHART) helm-repo-update plugins

$(COMMON_CHARTS_DIR):
	@echo "\n[$@]"
	@make package-$@

$(HELM_CHARTS): $(COMMON_CHARTS_DIR)
	@echo "\n[$@]"
	@make package-$@

$(SUBMODS): $(COMMON_CHARTS_DIR)
	@echo "\n[$@]"
	@make submod-$@
	@make package-$@

$(PARENT_CHART): $(HELM_CHARTS)
	@echo "\n[$@]"
	@make package-$@

submod-%:
	@make $*/Chart.yaml

%/Chart.yaml:
	$(error Submodule $* needs to be retrieved from gerrit.  See https://wiki.onap.org/display/DW/OOM+-+Development+workflow+after+code+transfer+to+tech+teams ); fi

print_helm_bin:
	$(info Using Helm binary ${HELM_BIN} which is helm version ${HELM_VER})

make-%:
	@if [ -f $*/Makefile ]; then make -C $*; fi

dep-%: make-%
	@if [ -f $*/Chart.yaml ]; then $(HELM_BIN) dep up $*; fi

lint-%: dep-%
	@if [ -f $*/Chart.yaml ]; then $(HELM_LINT_CMD) $*; fi

package-%: lint-%
	@mkdir -p $(PACKAGE_DIR)
	@if [ -f $*/Chart.yaml ]; then PACKAGE_NAME=$$($(HELM_BIN) package -d $(PACKAGE_DIR) $* | cut -d":" -f2) && $(HELM_BIN) cm-push -f $$PACKAGE_NAME $(HELM_REPO); fi
	@sleep 3

clean:
	@rm -f */Chart.lock
	@find . -type f -name '*.tgz' -delete
	@rm -rf $(PACKAGE_DIR)/*

# publish helm plugins via distrubtion directory
plugins:
	@mkdir -p $(PACKAGE_DIR)
	@cp -R helm $(PACKAGE_DIR)/

check-for-staging-images:
	$(ROOT_DIR)/../.ci/check-for-staging-images.sh

helm-repo-update: $(PARENT_CHART)
	@$(HELM_BIN) repo update

%:
	@: