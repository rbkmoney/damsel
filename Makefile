THRIFT_EXEC = thrift
THRIFT_LANGUAGES = erlang go java
THRIFT_OPTIONS_erlang = scoped_typenames
THRIFT_OPTIONS_java = fullcamel
THRIFT_OPTIONS_html = standalone
JAVA_COMPILE = javac
JAVA_NEXUS = http://java-nexus.msk1.rbkmoney.net:8081/nexus/service/local/artifact/maven/redirect
JAVA_NAMESPACE = com/rbkmoney/damsel
JAVA_COMPILE_FOLDER = out_java
JAVA_DEPENDS_FOLDER = lib
JAVA_DEPENDS_LIBTRIFT = libthrift.jar
JAVA_DEPENDS_WOODY_API = woody-api.jar
JAVA_DEPENDS_WOODY_THRIFT = woody-thrift.jar
JAVA_DEPENDS_SLF4J_API = slf4j-api.jar

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
	rm -rf $(JAVA_DEPENDS_FOLDER)
	rm -rf $(JAVA_COMPILE_FOLDER)

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

$(TARGETS):: $(DESTDIR)/$(LANGUAGE)/%: %

	@if [ ! -d "lib" ]; then     \
		echo "Load depends: start"; \
		echo "Create folder " $(JAVA_DEPENDS_FOLDER) "out_"$(LANGUAGE); \
		mkdir -p $(JAVA_DEPENDS_FOLDER) && mkdir -p "out_"$(LANGUAGE); \
		 \
		wget -O $(JAVA_DEPENDS_FOLDER)"/"$(JAVA_DEPENDS_LIBTRIFT) $(JAVA_NEXUS)"?r=releases&g=com.rbkmoney.thrift&a=libthrift&v=LATEST"; \
		wget -O $(JAVA_DEPENDS_FOLDER)"/"$(JAVA_DEPENDS_WOODY_API)  $(JAVA_NEXUS)"?r=releases&g=com.rbkmoney.woody&a=woody-api&v=LATEST"; \
		wget -O $(JAVA_DEPENDS_FOLDER)"/"$(JAVA_DEPENDS_WOODY_THRIFT)  $(JAVA_NEXUS)"?r=releases&g=com.rbkmoney.woody&a=woody-thrift&v=LATEST"; \
		wget -O $(JAVA_DEPENDS_FOLDER)"/"$(JAVA_DEPENDS_SLF4J_API)  $(JAVA_NEXUS)"?r=central&g=org.slf4j&a=slf4j-api&v=LATEST"; \
		 \
		echo "Load depends: end"; \
	fi

	@echo $(CUTLINE);
	@echo "Compile '$(LANGUAGE)' ...";
	@for folder in $@; \
	do \
		echo "Compile: " $$folder; \
		$(JAVA_COMPILE) -Xdiags:verbose -g \
		-classpath $(JAVA_DEPENDS_FOLDER)"/"$(JAVA_DEPENDS_LIBTRIFT)":"$(JAVA_DEPENDS_FOLDER)"/"$(JAVA_DEPENDS_WOODY_API)":"$(JAVA_DEPENDS_FOLDER)"/"$(JAVA_DEPENDS_WOODY_THRIFT)":"$(JAVA_DEPENDS_FOLDER)"/"$(JAVA_DEPENDS_SLF4J_API) \
		$$folder/$(JAVA_NAMESPACE)/*/*.$(LANGUAGE) \
		-d "out_"$(LANGUAGE); \
	done
	@echo "Compile: '$(LANGUAGE)' done";
	@echo $(CUTLINE);

endif
endif