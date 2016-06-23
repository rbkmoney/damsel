THRIFT_EXEC = thrift
THRIFT_LANGUAGES = erlang go java
THRIFT_OPTIONS_erlang = scoped_typenames
THRIFT_OPTIONS_java = fullcamel
THRIFT_OPTIONS_html = standalone

FILES = $(wildcard proto/*.thrift)
DESTDIR = _gen

define generate
	$(THRIFT_EXEC) -r -strict --gen $(1):$(THRIFT_OPTIONS_$(1)) -out $(2) $(3)
endef

define targets
	$(patsubst %, $(DESTDIR)/$(1)/%, $(FILES))
endef

CUTLINE = $(shell printf '=%.0s' $$(seq 1 80))

.PHONY: all clean doc

LANGUAGE_TARGETS = $(foreach lang, $(THRIFT_LANGUAGES), verify-$(lang))

all: $(LANGUAGE_TARGETS)
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

# wercker

WERCKERDIRS = _builds _cache _projects _steps _temp

clean::
	rm -rf $(WERCKERDIRS)

# Erlang

ERLC ?= erlc

ifeq ($(LANGUAGE), erlang)
ifneq ($(shell which $(ERLC)),)

$(TARGETS):: $(DESTDIR)/$(LANGUAGE)/%: %
	$(ERLC) -v -I$@ -o$@ $(shell find $@ -name "*.erl")

endif
endif


# Java

JAVAC ?= javac

ifeq ($(LANGUAGE), java)
ifneq ($(shell which $(JAVAC)),)

JAVA_NEXUS = http://java-nexus.msk1.rbkmoney.net:8081/nexus/service/local/artifact/maven/redirect

JAVA_DEPS = libthrift woody-api woody-thrift slf4j-api
JAVA_DEP_DIR = $(DESTDIR)/java_libs
JAVA_DEP_FILES = $(patsubst %,$(JAVA_DEP_DIR)/%.jar,$(JAVA_DEPS))

JAVA_OUT_DIR = $@/build

$(TARGETS):: $(DESTDIR)/$(LANGUAGE)/%: % $(JAVA_DEP_FILES)
	@echo "Compiling artifacts:" $@ "..."
	@mkdir -p $(JAVA_OUT_DIR)
	@$(JAVAC) \
		-Xdiags:verbose -g \
		-classpath $(subst $(eval) ,:,$(JAVA_DEP_FILES)) \
		$(shell find $@ -type f -name '*.java') \
		-d $(JAVA_OUT_DIR)

JAVA_DEP_libthrift    = releases com.rbkmoney.thrift
JAVA_DEP_woody-api    = releases com.rbkmoney.woody
JAVA_DEP_woody-thrift = releases com.rbkmoney.woody
JAVA_DEP_slf4j-api    = central org.slf4j

$(JAVA_DEP_DIR)/%.jar:
	@mkdir -p $(JAVA_DEP_DIR)
	@wget -nv -O $@ "$(JAVA_NEXUS)?r=$(word 1,$(JAVA_DEP_$*))&g=$(word 2,$(JAVA_DEP_$*))&a=$*&v=LATEST"

endif
endif
