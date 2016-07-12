THRIFT_EXEC = $(shell which thrift)
THRIFT_LANGUAGES = erlang go java
THRIFT_OPTIONS_erlang = scoped_typenames
THRIFT_OPTIONS_java = fullcamel
THRIFT_OPTIONS_html = standalone

RELNAME := dev

FILES = $(wildcard proto/*.thrift)
DESTDIR = _gen

DOCKER = $(call which,docker)

CALL_ANYWHERE := clean all compile doc deploy_nexus
CALL_W_CONTAINER := $(CALL_ANYWHERE)

include utils.mk

define generate
	$(THRIFT_EXEC) -r -strict --gen $(1):$(THRIFT_OPTIONS_$(1)) -out $(2) $(3)
endef

define targets
	$(patsubst %, $(DESTDIR)/$(1)/%, $(FILES))
endef

CUTLINE = $(shell printf '=%.0s' $$(seq 1 80))

.PHONY: $(CALL_W_CONTAINER) all compile w_container_% $(UTIL_TARGETS)

LANGUAGE_TARGETS = $(foreach lang, $(THRIFT_LANGUAGES), verify-$(lang))

all: compile

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
	mvn -s settings.xml compile

deploy_nexus:
	mvn -s settings.xml versions:set versions:commit -DnewVersion="$(COMMIT_HASH)" \
	&& mvn deploy -s settings.xml -Dpath_to_thrift="$(THRIFT_EXEC)"
