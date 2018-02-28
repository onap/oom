PARENT_CHART := onap
COMMON_CHARTS_DIR := common
SETUP_CHARTS_DIR := setup
#Order is important
SHARED_CHARTS := common setup mysql dgbuilder
# FIXME OOM-765
ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
OUTPUT_DIR := $(ROOT_DIR)/dist
PACKAGE_DIR := $(OUTPUT_DIR)/packages
SECRET_DIR := $(OUTPUT_DIR)/secrets

EXCLUDES := $(SHARED_CHARTS) config oneclick readiness test dist $(PARENT_CHART) dcae
HELM_CHARTS := $(filter-out $(EXCLUDES), $(patsubst %/.,%,$(wildcard */.))) $(PARENT_CHART)

.PHONY: $(EXCLUDES) $(HELM_CHARTS)

all: $(SHARED_CHARTS) $(HELM_CHARTS)

$(SHARED_CHARTS):
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

package-%: lint-%
	@mkdir -p $(PACKAGE_DIR)
	@if [ -f $*/Chart.yaml ]; then helm package -d $(PACKAGE_DIR) $*; fi

clean:
	@rm -f */requirements.lock
	@rm -f *tgz */charts/*tgz
	@rm -rf $(PACKAGE_DIR)
%:
	@: