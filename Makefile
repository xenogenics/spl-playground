#
# Copyright (c) 2021 Xavier R. Guérin xguerin@users.noreply.github.com
# 
# Permission to use, copy, modify, and distribute this software for any purpose
# with or without fee is hereby granted, provided that the above copyright
# notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#

DOCKER_NAMESPACE ?= $(USER)
DOCKER_REGISTRY ?= localhost:5000

SPLC_FLAGS = -a
SPL_CMD_ARGS ?= 

BUILD_TYPE ?= debug

.PHONY: all clean 

all: custommetrics dynamic parallel

clean:
	@rm -rf build toolkit.xml

ifeq ($(DOCKER),)

custommetrics: apps/custommetrics/CustomMetrics.spl
	@docker run -it --rm \
		-v $(PWD):$(PWD):rw \
		-v $(HOME)/.m2:/home/builder/.m2:rw \
		$(DOCKER_REGISTRY)/$(DOCKER_NAMESPACE)/streams-runtime:6.$(BUILD_TYPE) \
		doas $(shell id -u) $(shell id -g) $(PWD) \
		make custommetrics

dynamic: apps/dynamic/DynamicUDPSimple.spl
	@docker run -it --rm \
		-v $(PWD):$(PWD):rw \
		-v $(HOME)/.m2:/home/builder/.m2:rw \
		$(DOCKER_REGISTRY)/$(DOCKER_NAMESPACE)/streams-runtime:6.$(BUILD_TYPE) \
		doas $(shell id -u) $(shell id -g) $(PWD) \
		make dynamic

parallel: apps/parallel/Parallel.spl
	@docker run -it --rm \
		-v $(PWD):$(PWD):rw \
		-v $(HOME)/.m2:/home/builder/.m2:rw \
		$(DOCKER_REGISTRY)/$(DOCKER_NAMESPACE)/streams-runtime:6.$(BUILD_TYPE) \
		doas $(shell id -u) $(shell id -g) $(PWD) \
		make parallel

else

custommetrics: apps/custommetrics/CustomMetrics.spl
	@$(STREAMS_INSTALL)/bin/sc \
		$(SPLC_FLAGS) \
		--output-dir=build/custommetrics \
		-M apps.custommetrics::CustomMetrics \
		$(SPL_CMD_ARGS)

dynamic: apps/dynamic/DynamicUDPSimple.spl
	@$(STREAMS_INSTALL)/bin/sc \
		$(SPLC_FLAGS) \
		--output-dir=build/dynamic \
		-M apps.dynamic::DynamicUDPSimple \
		$(SPL_CMD_ARGS)

parallel: apps/parallel/Parallel.spl
	@$(STREAMS_INSTALL)/bin/sc \
		$(SPLC_FLAGS) \
		--output-dir=build/parallel \
		-M apps.parallel::Parallel \
		$(SPL_CMD_ARGS)

endif
