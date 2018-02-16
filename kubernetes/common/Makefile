EXCLUDES := test
HELM_CHARTS := $(filter-out $(EXCLUDES), $(patsubst %/.,%,$(wildcard */.)))

.PHONY: $(EXCLUDES) $(HELM_CHARTS)

all: $(HELM_CHARTS)

$(HELM_CHARTS):
	@echo "\n[$@]"
	@make lint-$@

make-%:
	@if [ -f $*/Makefile ]; then make -C $*; fi

dep-%: make-%
	@if [ -f $*/requirements.yaml ]; then helm dep up $*; fi

lint-%: dep-%
	@if [ -f $*/Chart.yaml ]; then helm lint $*; fi

clean:
	@rm -f */requirements.lock
	@rm -f *tgz */charts/*tgz
%:
	@: