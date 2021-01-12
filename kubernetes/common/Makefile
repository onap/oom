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
PROCESSED_LAST := cert-wrapper repository-wrapper
PROCESSED_FIRST := repositoryGenerator readinessCheck certInitializer
TO_FILTER := $(PROCESSED_FIRST) $(EXCLUDES) $(PROCESSED_LAST)

HELM_BIN := helm
HELM_CHARTS := $(PROCESSED_FIRST) $(filter-out $(TO_FILTER), $(sort $(patsubst %/.,%,$(wildcard */.)))) $(PROCESSED_LAST)
HELM_VER := $(shell $(HELM_BIN) version --template "{{.Version}}")

.PHONY: $(HELM_CHARTS) $(TO_FILTER)

all: $(COMMON_CHARTS_DIR) $(HELM_CHARTS)

$(HELM_CHARTS):
	@echo "\n[$@]"
	@make package-$@

make-%:
	@if [ -f $*/Makefile ]; then make -C $*; fi

dep-%: make-%
	@if [ -f $*/requirements.yaml ]; then $(HELM_BIN) dep up $*; fi

lint-%: dep-%
	@if [ -f $*/Chart.yaml ]; then $(HELM_BIN) lint $*; fi

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
	@rm -f *tgz */charts/*tgz
	@rm -rf $(PACKAGE_DIR)
%:
	@:
