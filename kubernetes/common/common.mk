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
ROOT_DIR ?= $(error ROOT_DIR undefined)
OUTPUT_DIR ?= $(error OUTPUT_DIR undefined) 
EXCLUDES ?= $(error EXCLUDES undefined)
PACKAGE_NAME ?= $(error PACKAGE_NAME undefined)

HELM_BIN := helm
PACKAGE_DIR := $(OUTPUT_DIR)/packages
SECRET_DIR := $(OUTPUT_DIR)/secrets
SUM_DIR := $(OUTPUT_DIR)/sum
VERSION := $(shell cat '$(ROOT_DIR)/Chart.yaml' | yq -r '.version')
HELM_DEP_LIST := $(shell  helm dep list . | tr '\n' '\1')
DEP_LOCAL_DIR := $(shell echo "$(HELM_DEP_LIST)" | tr '\1' '\n' | grep file:// | cut -f3 | sed -e 's/file:\/\// /g')
DEP_LOCAL_ARCH := $(foreach dep, $(DEP_LOCAL_DIR), $(PACKAGE_DIR)/$(shell printf "$$(cat $(dep)/Chart.yaml | yq -r '.name')-$$(cat $(dep)/Chart.yaml | yq -r '.version')").tgz)
DEP_LOCAL := $(shell echo $(HELM_DEP_LIST) | tr '\1' '\n' | grep file:// | cut -d" " -f1 | tr "\n" " " | sed -e 's/\s*$$//g' -e 's/\s\+/ /g')
DEP_LOCAL_REG := $(shell echo $(DEP_LOCAL) | tr '\1' '\n' | sed 's/ /|/g')

.PHONY:  $(SUM_DIR)/$(PACKAGE_NAME).sum $(SUM_DIR)/$(PACKAGE_NAME).sum.filtered $(DEP_LOCAL_DIR)

ifneq ($(SKIP_LINT),TRUE)
HELM_LINT_CMD := $(HELM_BIN) lint
else
HELM_LINT_CMD := echo "Skipping linting of"
endif

ifneq ($(DEP_LOCAL_DIR),)
$(DEP_LOCAL_DIR):
	@echo "Rebuld dep [$@]"
	if [ -f $@/Makefile ]; then\
		PACKAGE_NAME=$$(basename $@);\
		$(MAKE) -C $@ PACKAGE_NAME=$$PACKAGE_NAME;\
	fi
endif

$(DEP_LOCAL_ARCH):
	@echo "DEP_LOCAL_ARCH"

$(PACKAGE_NAME):$(SUM_DIR)/$(PACKAGE_NAME).sum.filtered $(DEP_LOCAL_DIR)
	@echo "\n[$@]"
	@$(HELM_BIN) dependency up 
	@if [ ! -s $< ] || md5sum -c $< > /dev/null; then \
		DEP=$$(find . -type f -not -name "*.tgz" | tr "\n" " ");\
	else \
		DEP=$$(find . -type f  | tr "\n" " ");\
	fi ;\
	$(MAKE) $(PACKAGE_DIR)/$@-$(VERSION).tgz \
		PACKAGE_NAME=$@ \
		VERSION=$(VERSION) \
		DEP="$$DEP $$DEP_LOCAL_FILES";\

$(SUM_DIR)/$(PACKAGE_NAME).sum.filtered: $(SUM_DIR) $(SUM_DIR)/$(PACKAGE_NAME).sum
	@echo "\n[$@] -sum.filtered"
ifneq ($(DEP_LOCAL),)
	@grep -vE "$(DEP_LOCAL)" $(SUM_DIR)/$(PACKAGE_NAME).sum > $@
else
	@cp $(SUM_DIR)/$(PACKAGE_NAME).sum $@
endif

$(SUM_DIR)/$(PACKAGE_NAME).sum:
	@echo "\n[$@] - sum"
	@mkdir -p $(SUM_DIR)
	@find charts -type f -exec md5sum '{}' \; > $@

$(SUM_DIR):
	@echo "\n[$@] - sum dir"
	@mkdir -p $(SUM_DIR)

$(PACKAGE_DIR)/%-$(VERSION).tgz: $(DEP) $(DEP_LOCAL_ARCH)
	@echo make [$@].tgz
	@$(HELM_LINT_CMD) 
	@mkdir -p $(PACKAGE_DIR)
ifeq "$(findstring v3,$(HELM_VER))" "v3"
	@PCKG_NAME=$$($(HELM_BIN) package -d $(PACKAGE_DIR) . | cut -d":" -f2) && $(HELM_BIN) push -f $$PCKG_NAME local
else
	@$(HELM_BIN) package -d $(PACKAGE_DIR) .
endif
	@$(HELM_BIN) repo index $(PACKAGE_DIR)

clean:
	@rm -f */requirements.lock
	@rm -f *tgz */charts/*tgz
	@rm -rf $(PACKAGE_DIR)

%:
	@:
