THRIFT = $(or $(shell which thrift), $(error "`thrift' executable missing"))
REBAR = $(shell which rebar3 2>/dev/null || which ./rebar3)
SUBMODULES = build_utils
SUBTARGETS = $(patsubst %,%/.git,$(SUBMODULES))

UTILS_PATH := build_utils
TEMPLATES_PATH := .

# Name of the service
SERVICE_NAME := damsel

# Build image tag to be used
BUILD_IMAGE_TAG := b04c5291d101132e53e578d96e1628d2e6dab0c0
CALL_ANYWHERE := \
	all submodules rebar-update compile release-erlang clean distclean

PROTODIR = proto
FILES = $(wildcard $(PROTODIR)/*.thrift)
DESTDIR = _gen
RELDIR = _release
CUTLINE = $(shell printf '=%.0s' $$(seq 1 80))
REPODIR = $(abspath $(RELDIR)/$*)
TARGETS = $(call targets,$(LANGUAGE))

CALL_W_CONTAINER := $(CALL_ANYWHERE)

all: compile

-include $(UTILS_PATH)/make_lib/utils_container.mk

.PHONY: $(CALL_W_CONTAINER)

# CALL_ANYWHERE
$(SUBTARGETS): %/.git: %
	git submodule update --init $<
	touch $@

submodules: $(SUBTARGETS)

rebar-update:
	$(REBAR) update

compile: submodules rebar-update
	$(REBAR) compile

release-%: $(RELDIR)
	@echo "Making '$*' release ..."
	@echo $(CUTLINE)
	@rm -rf $(REPODIR)
	$(MAKE) LANGUAGE=$* DESTDIR=$(REPODIR) build-release

clean:
	$(REBAR) clean

distclean:
	$(REBAR) clean -a
	rm -rfv _build _builds _cache _steps _temp

# Erlang

ERLC ?= erlc

ifeq ($(LANGUAGE), erlang)
ifneq ($(shell which $(ERLC)),)

$(TARGETS):: $(DESTDIR)/$(LANGUAGE)/%: %
	$(ERLC) -v -I$@ -o$@ $(shell find $@ -name "*.erl")

build-release:
	@make THRIFT="$(THRIFT)" FILES="$(abspath $(FILES))" PROTO="$(abspath $(PROTODIR))" -C build/erlang release

endif
endif

include $(UTILS_PATH)/make_lib/java_proto.mk
