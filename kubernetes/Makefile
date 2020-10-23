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

.PHONY: $(EXCLUDES) $(HELM_CHARTS)

all: $(COMMON_CHARTS_DIR) $(SUBMODS) $(HELM_CHARTS) plugins

$(SUBMODS):
	@echo "\n[$@]"
	@make submod-$@

submod-%:
	@make $*/requirements.yaml

%/requirements.yaml:
	$(error Submodule $* needs to be retrieved from gerrit.  See https://wiki.onap.org/display/DW/OOM+-+Development+workflow+after+code+transfer+to+tech+teams ); fi


$(COMMON_CHARTS) $(HELM_CHARTS):
	@echo "\n[$@]"
	@if [ -f $@/Makefile ]; then\
		$(MAKE) -C $@; \
	elif [ -f $@/Chart.yaml ]; then\
	    VERSION=$$(cat $@/Chart.yaml | yq -r '.version' );\
		echo $$VERSION;\
		md5sum $@/charts/* > /tmp/$@.sum;\
		DEP_LOCAL=$$(helm dep list $@ | grep file:// | cut -f1 | tr "\n" " " | sed -e 's/\s*$$//g' -e 's/\s\+/ /g' -e 's/ /|/g');\
		DEP_LOCAL_DIR=$$(helm dep list $@ | grep file:// | cut -f3 | sed -e 's/file:\/\//$@\//g');\
		echo DEP LOCAL: $$DEP_LOCAL;\
		grep -vE "$$DEP_LOCAL" /tmp/$@.sum > /tmp/$@.sum.filtered;\
		$(HELM_BIN) dep up $@ ;\
		if [ ! -s /tmp/$@.sum.filtered ] || md5sum -c /tmp/$@.sum.filtered; then \
			DEP=$$(find $@ -type f -not -name "*.tgz" | tr "\n" " ");\
		else \
			DEP=$$(find $@ -type f  | tr "\n" " ");\
		fi;\
		if [ -n "$$DEP_LOCAL_DIR" ]; then \
			DEP_LOCAL_FILES=$$(find $$DEP_LOCAL_DIR -type f | tr "\n" " ");\
		fi;\
		$(MAKE) $(PACKAGE_DIR)/$@-$$VERSION.tgz \
			PACKAGE_NAME=$@ \
			VERSION=$$VERSION \
			DEP="$$DEP $$DEP_LOCAL_FILES";\
	fi

$(PACKAGE_DIR)/%-$(VERSION).tgz: $(DEP)
	@echo make $@
	@$(HELM_BIN) lint $*
	@mkdir -p $(PACKAGE_DIR)
ifeq "$(findstring v3,$(HELM_VER))" "v3"
	@PACKAGE_NAME=$$($(HELM_BIN) package -d $(PACKAGE_DIR) $* | cut -d":" -f2) && $(HELM_BIN) push -f $$PACKAGE_NAME local
else
	@$(HELM_BIN) package -d $(PACKAGE_DIR) $*
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
%:
	@:
