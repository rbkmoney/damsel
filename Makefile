THRIFT = $(or $(shell which thrift), $(error "`thrift' executable missing"))
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


BUILD_IMAGE_TAG := 4536c31941b9c27c134e8daf0fd18848809219c9

PROTODIR = proto
FILES = $(wildcard $(PROTODIR)/*.thrift)
DESTDIR = _gen
RELDIR = _release

CALL_W_CONTAINER := \
	all compile doc clean \
	java.compile java.deploy java.install java.settings \
	release-erlang

all: compile

-include $(UTILS_PATH)/make_lib/utils_container.mk

define generate
	$(THRIFT) -r -strict --gen $(1):$(THRIFT_OPTIONS_$(1)) -out $(2) $(3)
endef

define targets
	$(patsubst %, $(DESTDIR)/$(1)/%, $(FILES))
endef

CUTLINE = $(shell printf '=%.0s' $$(seq 1 80))

.PHONY: all compile doc clean java.compile java.deploy java.install java.settings

LANGUAGE_TARGETS = $(foreach lang, $(THRIFT_LANGUAGES), verify-$(lang))

compile: $(LANGUAGE_TARGETS)
	@echo "Ok"

verify-%: $(DESTDIR)
	@echo "Verifying '$*' ..."
	@echo $(CUTLINE)
	@$(MAKE) LANGUAGE=$* $(call targets,$*)
	@echo

TARGETS = $(call targets,$(LANGUAGE))

$(TARGETS):: $(DESTDIR)/$(LANGUAGE)/%: %
	mkdir -p $@
	$(call generate,$(LANGUAGE),$@,$<)

clean::
	rm -rf $(DESTDIR)

REPODIR = $(abspath $(RELDIR)/$*)
DOCKER_RUN_OPTS := -e BRANCH_NAME

release-%: $(RELDIR)
	@echo "Making '$*' release ..."
	@echo $(CUTLINE)
	@rm -rf $(REPODIR)
	$(MAKE) LANGUAGE=$* DESTDIR=$(REPODIR) build-release

clean::
	rm -rf $(RELDIR)

$(DESTDIR):
$(RELDIR):
	@mkdir -p $@

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

build-release:
	@make THRIFT="$(THRIFT)" FILES="$(abspath $(FILES))" PROTO="$(abspath $(PROTODIR))" -C build/erlang release

endif
endif

# Java

MVN = mvn --no-transfer-progress --batch-mode

ifdef SETTINGS_XML
DOCKER_RUN_OPTS = -v "$(SETTINGS_XML):$(SETTINGS_XML)"
DOCKER_RUN_OPTS += -e SETTINGS_XML="$(SETTINGS_XML)"
MVN += -s "$(SETTINGS_XML)"
endif

ifdef MVN_PROFILE
DOCKER_RUN_OPTS += -e MVN_PROFILE="$(MVN_PROFILE)"
endif

ifdef LOCAL_BUILD
DOCKER_RUN_OPTS += -v $$HOME/.m2:/home/$(UNAME)/.m2:rw
endif

COMMIT_HASH = $(shell git --no-pager log -1 --pretty=format:"%h")
NUMBER_COMMITS = $(shell git rev-list --count HEAD)
MVN += -Dpath_to_thrift="$(THRIFT)" -Dcommit.number="$(NUMBER_COMMITS)"

JAVA_PKG_VERSION := 1.$(NUMBER_COMMITS)-$(COMMIT_HASH)

ifdef BRANCH_NAME
ifeq "$(findstring epic,$(BRANCH_NAME))" "epic"
JAVA_PKG_VERSION := $(JAVA_PKG_VERSION)-epic
endif
endif

java.compile: java.settings
	$(MVN) compile

java.deploy: java.settings
	$(MVN) versions:set versions:commit -DnewVersion="$(JAVA_PKG_VERSION)" && \
	$(MVN) deploy -Dgpg.keyname="$$GPG_KEYID" -Dgpg.passphrase="$$GPG_PASSPHRASE"

java.install: java.settings
	$(MVN) clean && \
	$(MVN) versions:set versions:commit -DnewVersion="$(JAVA_PKG_VERSION)" && \
	$(MVN) install

java.settings:
	$(if $(SETTINGS_XML),, echo "SETTINGS_XML not defined"; exit 1)
	$(MVN) help:all-profiles && \
  $(MVN) help:effective-pom
