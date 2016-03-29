THRIFT_EXEC = thrift
THRIFT_LANGUAGES = erlang go java

FILES = $(wildcard proto/*.thrift)
DESTDIR = _gen

define generate
	$(THRIFT_EXEC) -r -strict --gen $(1):$(THRIFT_OPTIONS_$(1)) -out $(2) $(3)
endef

define targets
	$(patsubst %, $(DESTDIR)/$(1)/%, $(FILES))
endef

CUTLINE = $(shell printf '=%.0s' $$(seq 1 80))

.PHONY: all clean

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

clean:
	@rm -rfv $(DESTDIR)

TARGETS = $(call targets,$(LANGUAGE))

$(TARGETS):: $(DESTDIR)/$(LANGUAGE)/%: %
	mkdir -p $@
	$(call generate,$(LANGUAGE),$@,$<)

# Erlang

ifeq ($(LANGUAGE), erlang)
ERLC = erlc -v
$(TARGETS):: $(DESTDIR)/$(LANGUAGE)/%: %
	$(ERLC) -I$@ -o$@ $(shell find $@ -name "*.erl")
endif
