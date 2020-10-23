# Copyright © 2020 Samsung Electronics
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

EXCLUDES :=
HELM_BIN := helm
HELM_CHARTS := $(filter-out $(EXCLUDES), $(sort $(patsubst %/.,%,$(wildcard */.))))

.PHONY: all $(HELM_CHARTS) clean

all: $(HELM_CHARTS)

$(HELM_CHARTS):
	@if [ -f $@/Makefile ]; then \
		$(MAKE) -C $@;\
	fi

%:
	@:
