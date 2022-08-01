# Copyright © 2020 Samsung Electronics
# Copyright (c) 2021 AT&T. All rights reserved.
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

ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
OUTPUT_DIR := $(ROOT_DIR)/../../dist
PACKAGE_DIR := $(OUTPUT_DIR)/packages
SECRET_DIR := $(OUTPUT_DIR)/secrets

HELM_REPO := local

EXCLUDES :=
HELM_BIN := helm
ifneq ($(SKIP_LINT),TRUE)
	HELM_LINT_CMD := $(HELM_BIN) lint
else
	HELM_LINT_CMD := echo "Skipping linting of"
endif

# Helm v2 and helm v3 uses different version format so we first try in helm v3 format
# and if it fails then we fallback to helm v2 one
HELM_VER := $(shell $(HELM_BIN) version --template "{{.Version}}" 2>/dev/null)
ifneq "$(findstring v3,$(HELM_VER))" "v3"
	HELM_VER := $(shell $(HELM_BIN) version -c --template "{{.Client.SemVer}}")
endif

HELM_CHARTS := $(filter-out $(EXCLUDES), $(sort $(patsubst %/.,%,$(wildcard */.))))

.PHONY: $(EXCLUDES) $(HELM_CHARTS)

all: $(HELM_CHARTS) helm-repo-update

$(HELM_CHARTS):
	@echo "\n[$@]"
	@make package-$@

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
	#@$(HELM_BIN) repo index $(PACKAGE_DIR)

clean:
	@rm -f */Chart.lock
	@rm -f *tgz */charts/*tgz
	@rm -rf $(PACKAGE_DIR)

helm-repo-update:
ifeq "$(findstring v3,$(HELM_VER))" "v3"
	@$(HELM_BIN) repo update
endif

%:
	@:
