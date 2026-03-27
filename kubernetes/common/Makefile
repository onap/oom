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
PROCESSED_LAST := repository-wrapper
PROCESSED_FIRST := repositoryGenerator readinessCheck serviceAccount cmpv2Config
TO_FILTER := $(COMMON_CHARTS_DIR) $(PROCESSED_FIRST) $(EXCLUDES) $(PROCESSED_LAST)

HELM_BIN := helm
ifneq ($(SKIP_LINT),TRUE)
	HELM_LINT_CMD := $(HELM_BIN) lint
else
	HELM_LINT_CMD := echo "Skipping linting of"
endif

HELM_CHARTS := $(filter-out $(TO_FILTER), $(sort $(patsubst %/.,%,$(wildcard */.))))
HELM_VER := $(shell $(HELM_BIN) version --template "{{.Version}}")

.PHONY: $(HELM_CHARTS) $(TO_FILTER)

all: $(COMMON_CHARTS_DIR) $(PROCESSED_FIRST) $(HELM_CHARTS) $(PROCESSED_LAST)

$(COMMON_CHARTS_DIR):
	@echo "\n[$@]"
	@$(MAKE) package-$@

$(PROCESSED_FIRST): $(COMMON_CHARTS_DIR)
	@echo "\n[$@]"
	@$(MAKE) package-$@

# readinessCheck depends on repositoryGenerator at the Chart.yaml level
readinessCheck: repositoryGenerator

$(HELM_CHARTS): $(PROCESSED_FIRST)
	@echo "\n[$@]"
	@$(MAKE) package-$@

$(PROCESSED_LAST): $(HELM_CHARTS)
	@echo "\n[$@]"
	@$(MAKE) package-$@

make-%:
	@if [ -f $*/Makefile ]; then $(MAKE) -C $*; fi

dep-%: make-%
	@if [ -f $*/Chart.yaml ]; then $(HELM_BIN) dep up $*; fi

lint-%: dep-%
	@if [ -f $*/Chart.yaml ]; then $(HELM_LINT_CMD) $*; fi

package-%: lint-%
	@mkdir -p $(PACKAGE_DIR)
	@if [ -f $*/Chart.yaml ]; then PACKAGE_NAME=$$($(HELM_BIN) package -d $(PACKAGE_DIR) $* | cut -d":" -f2) && $(HELM_BIN) cm-push -f $$PACKAGE_NAME local; fi
	@$(HELM_BIN) repo update local
	#@$(HELM_BIN) repo index $(PACKAGE_DIR)

clean:
	@rm -f */Chart.lock
	@rm -f *tgz */charts/*tgz
	@rm -rf $(PACKAGE_DIR)
%:
	@:
