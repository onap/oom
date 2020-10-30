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
HELM_BIN := helm
HELM_VER := $(shell $(HELM_BIN) version --template "{{.Version}}")

ifneq ($(SKIP_LINT),TRUE)
	HELM_LINT_CMD := $(HELM_BIN) lint
else
	HELM_LINT_CMD := echo "Skipping linting of"
endif

SUBMODS := robot aai
EXCLUDES := config oneclick readiness test dist helm $(PARENT_CHART) dcae $(SUBMODS)
HELM_CHARTS := $(filter-out $(EXCLUDES), $(sort $(patsubst %/.,%,$(wildcard */.)))) $(PARENT_CHART)

.PHONY: $(EXCLUDES) $(HELM_CHARTS) check-for-staging-images

all: $(COMMON_CHARTS_DIR) $(SUBMODS) $(HELM_CHARTS) plugins

$(COMMON_CHARTS):
	@echo "\n[$@]"
	@make package-$@

$(HELM_CHARTS):
	@echo "\n[$@]"
	@make package-$@

$(SUBMODS):
	@echo "\n[$@]"
	@make submod-$@
	@make package-$@

submod-%:
	@make $*/requirements.yaml

%/requirements.yaml:
	$(error Submodule $* needs to be retrieved from gerrit.  See https://wiki.onap.org/display/DW/OOM+-+Development+workflow+after+code+transfer+to+tech+teams ); fi


make-%:
	@if [ -f $*/Makefile ]; then make -C $*; fi

dep-%: make-%
	@if [ -f $*/requirements.yaml ]; then $(HELM_BIN) dep up $*; fi

lint-%: dep-%
	@if [ -f $*/Chart.yaml ]; then $(HELM_LINT_CMD) $*; fi

package-%: lint-%
	@mkdir -p $(PACKAGE_DIR)
ifeq "$(findstring v3,$(HELM_VER))" "v3"
	@if [ -f $*/Chart.yaml ]; then PACKAGE_NAME=$$($(HELM_BIN) package -d $(PACKAGE_DIR) $* | cut -d":" -f2) && $(HELM_BIN) push -f $$PACKAGE_NAME local; fi
else
	@if [ -f $*/Chart.yaml ]; then $(HELM_BIN) package -d $(PACKAGE_DIR) $*; fi
endif

	@$(HELM_BIN) repo index $(PACKAGE_DIR)

clean:
	@rm -f */requirements.lock
	@find . -type f -name '*.tgz' -delete
	@rm -rf $(PACKAGE_DIR)/*

# publish helm plugins via distrubtion directory
plugins:
	@cp -R $(HELM_BIN) $(PACKAGE_DIR)/

# start up a local helm repo to serve up helm chart packages
repo:
	@mkdir -p $(PACKAGE_DIR)
	@$(HELM_BIN) serve --repo-path $(PACKAGE_DIR) &
	@sleep 3
	@$(HELM_BIN) repo index $(PACKAGE_DIR)
	@$(HELM_BIN) repo add local http://127.0.0.1:8879

# stop local helm repo
repo-stop:
	@pkill $(HELM_BIN)
	@$(HELM_BIN) repo remove local

check-for-staging-images:
	@BASE_URL="https://nexus3.onap.org/repository/docker.release";\
	if [ "$$GERRIT_BRANCH" != "staging" ]; then \
		USED_IMAGES=$$(grep -r -E -o -h ':\s*onap/.*:.*' | sed -e 's/^: //' -e 's/^ //' | sort | uniq);\
		REPO_IMAGES=$$(curl -s $$BASE_URL/v2/_catalog | jq -r '.repositories[]');\
		NOT_AVALIABLE_IMAGES=$$(echo "$$USED_IMAGES" | grep -vE  "$$(echo "$$REPO_IMAGES" | tr "\n" "|" | sed "s/|$$//")");\
		USED_IMAGES=$$(echo "$$USED_IMAGES" | grep -E "$$(echo "$$REPO_IMAGES" | tr "\n" "|" | sed "s/|$$//")");\
		for i in $$USED_IMAGES; do \
			TMP_IMG=$$(echo "$$i" | cut -d ":" -f1);\
			TMP_TAG=$$(echo "$$i" | cut -d ":" -f2);\
			if [ "$$LAST_IMG" != "$$TMP_IMG" ]; then \
				AVALIABLE_TAGS=$$(curl -s $$BASE_URL/v2/$$TMP_IMG/tags/list | jq -r '.tags[]') ;\
			fi;\
			if ! echo "$$AVALIABLE_TAGS" | grep "$$TMP_TAG" > /dev/null; then \
				NOT_AVALIABLE_IMAGES="$$NOT_AVALIABLE_IMAGES\n$$i";\
			fi;\
			LAST_IMG="$$TMP_IMG";\
			printf ".";\
		done;\
		printf "\n";\
		if [ -n "$$NOT_AVALIABLE_IMAGES" ]; then\
			echo "[ERROR] Only release images are allowed in helm charts.";\
			echo "[ERROR] Images not found in release repo:";\
			echo -e "$$NOT_AVALIABLE_IMAGES";\
			exit 1;\
		fi;\
	fi


%:
	@:

