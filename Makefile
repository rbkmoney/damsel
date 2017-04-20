THRIFT_EXEC = $(or $(shell which thrift), $(error "`thrift' executable missing"))
THRIFT_LANGUAGES = erlang java
THRIFT_OPTIONS_erlang = scoped_typenames
THRIFT_OPTIONS_java = fullcamel
THRIFT_OPTIONS_html = standalone

UTILS_PATH := build_utils
TEMPLATES_PATH := .


# Name of the service
SERVICE_NAME := damsel
# Service image default tag
SERVICE_IMAGE_TAG ?= $(shell git rev-parse HEAD)
# The tag for service image to be pushed with
SERVICE_IMAGE_PUSH_TAG ?= $(SERVICE_IMAGE_TAG)


BUILD_IMAGE_TAG := 4fa802d2f534208b9dc2ae203e2a5f07affbf385

FILES = $(wildcard proto/*.thrift)
DESTDIR = _gen

CALL_W_CONTAINER := clean all create java_compile compile doc deploy_nexus deploy_epic_nexus java_install

all: compile

-include $(UTILS_PATH)/make_lib/utils_container.mk

define generate
	$(THRIFT_EXEC) -r -strict --gen $(1):$(THRIFT_OPTIONS_$(1)) -out $(2) $(3)
endef

define targets
	$(patsubst %, $(DESTDIR)/$(1)/%, $(FILES))
endef

CUTLINE = $(shell printf '=%.0s' $$(seq 1 80))

.PHONY: $(CALL_W_CONTAINER) create

LANGUAGE_TARGETS = $(foreach lang, $(THRIFT_LANGUAGES), verify-$(lang))


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

ifdef SETTINGS_XML
DOCKER_RUN_OPTS = -v $(SETTINGS_XML):$(SETTINGS_XML)
DOCKER_RUN_OPTS += -e SETTINGS_XML=$(SETTINGS_XML)
endif

ifdef LOCAL_BUILD
DOCKER_RUN_OPTS += -v $$HOME/.m2:/home/$(UNAME)/.m2:rw
endif

COMMIT_HASH = $(shell git --no-pager log -1 --pretty=format:"%h")
NUMBER_COMMITS = $(shell git rev-list --count HEAD)

java_compile:
	$(if $(SETTINGS_XML),,echo "SETTINGS_XML not defined" ; exit 1)
	mvn compile -s $(SETTINGS_XML)

deploy_nexus:
	$(if $(SETTINGS_XML),, echo "SETTINGS_XML not defined"; exit 1)
	mvn versions:set versions:commit -DnewVersion="1.$(NUMBER_COMMITS)-$(COMMIT_HASH)" -s $(SETTINGS_XML) \
	&& mvn deploy -s $(SETTINGS_XML) -Dpath_to_thrift="$(THRIFT_EXEC)" -Dcommit.number="$(NUMBER_COMMITS)"

deploy_epic_nexus:
	$(if $(SETTINGS_XML),, echo "SETTINGS_XML not defined"; exit 1)
	mvn versions:set versions:commit -DnewVersion="1.$(NUMBER_COMMITS)-$(COMMIT_HASH)-epic" -s $(SETTINGS_XML) \
	&& mvn deploy -s $(SETTINGS_XML) -Dpath_to_thrift="$(THRIFT_EXEC)" -Dcommit.number="$(NUMBER_COMMITS)"


java_install:
	$(if $(SETTINGS_XML),, echo "SETTINGS_XML not defined"; exit 1)
	mvn versions:set versions:commit -DnewVersion="1.$(NUMBER_COMMITS)-$(COMMIT_HASH)" -s $(SETTINGS_XML) \
	&& mvn install -s $(SETTINGS_XML) -Dpath_to_thrift="$(THRIFT_EXEC)" -Dcommit.number="$(NUMBER_COMMITS)"
