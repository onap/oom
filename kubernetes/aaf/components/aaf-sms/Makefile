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

ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
KUB_DIR := $(shell realpath ../../..)
OUTPUT_DIR := $(KUB_DIR)/dist
PACKAGE_NAME := $(shell yq read $(ROOT_DIR)/Chart.yaml 'name' )

.PHONY: all clean

all: $(PACKAGE_NAME)

include ../../../common/common.mk

%:
	@:

