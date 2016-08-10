THRIFT_EXEC = $(shell which thrift)
THRIFT_LANGUAGES = erlang java
THRIFT_OPTIONS_erlang = scoped_typenames
THRIFT_OPTIONS_java = fullcamel
THRIFT_OPTIONS_html = standalone

REGISTRY := dr.rbkmoney.com
ORG_NAME := rbkmoney
BASE_IMAGE := "$(REGISTRY)/$(ORG_NAME)/build:latest"

RELNAME := damsel

FILES = $(wildcard proto/*.thrift)
DESTDIR = _gen

CALL_ANYWHERE := clean all create java_compile compile doc deploy_nexus
CALL_W_CONTAINER := $(CALL_ANYWHERE)

BASE_IMAGE ?= rbkmoney/build

all: compile

include utils.mk

define generate
	$(THRIFT_EXEC) -r -strict --gen $(1):$(THRIFT_OPTIONS_$(1)) -out $(2) $(3)
endef

define targets
	$(patsubst %, $(DESTDIR)/$(1)/%, $(FILES))
endef

CUTLINE = $(shell printf '=%.0s' $$(seq 1 80))

.PHONY: $(CALL_W_CONTAINER) create $(UTIL_TARGETS)

LANGUAGE_TARGETS = $(foreach lang, $(THRIFT_LANGUAGES), verify-$(lang))

# Build failed without this file: _build/test/logs/index.html (Hi, jenkins_pipeline_lib)
create:
	mkdir -p _build/test/logs && touch _build/test/logs/index.html

compile: $(LANGUAGE_TARGETS)
	@echo "Ok"

verify-%: $(DESTDIR)
	@echo "Verifying '$*' ..."
	@echo $(CUTLINE)
	@$(MAKE) LANGUAGE=$* $(call targets,$*)
	@echo

$(DESTDIR):
	@mkdir -p $@

clean::
	rm -rf $(DESTDIR)

TARGETS = $(call targets,$(LANGUAGE))

$(TARGETS):: $(DESTDIR)/$(LANGUAGE)/%: %
	mkdir -p $@
	$(call generate,$(LANGUAGE),$@,$<)

# Docs

DOCDIR = doc
DOCTARGETS = $(patsubst %.thrift, $(DOCDIR)/%.html, $(FILES))

doc: $(DOCTARGETS)

$(DOCTARGETS): $(DOCDIR)/%.html: %.thrift
	mkdir -p $(dir $@)
	$(call generate,html,$(dir $@),$<)


# Erlang

ERLC ?= erlc

ifeq ($(LANGUAGE), erlang)
ifneq ($(shell which $(ERLC)),)

$(TARGETS):: $(DESTDIR)/$(LANGUAGE)/%: %
	$(ERLC) -v -I$@ -o$@ $(shell find $@ -name "*.erl")

endif
endif


COMMIT_HASH = $(shell git --no-pager log -1 --pretty=format:"%h")

java_compile:
	mvn compile

deploy_nexus:
	mvn versions:set versions:commit -DnewVersion="$(COMMIT_HASH)" \
	&& mvn deploy -Dpath_to_thrift="$(THRIFT_EXEC)"
