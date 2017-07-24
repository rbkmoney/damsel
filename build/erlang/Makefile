REBAR := $(shell which rebar3 2>/dev/null || which ./rebar3)

define gen
	$(THRIFT) --gen erlang:scoped_typenames,app_prefix=dmsl -out src $(1)

endef

release: generate lint xref dialyze publish

generate: $(FILES)
	$(patsubst %, $(call gen,%), $(FILES))
	@mv -v src/*.hrl include/

lint:
	elvis rock

xref:
	$(REBAR) xref

dialyze:
	$(REBAR) dialyzer

distclean:
	@rm -rf _build
	@rm -vf src/*_thrift.?rl include/*_thrift.?rl

DESTDIR ?= release
ARTIFACTS := \
	include \
	src \
	elvis.config \
	rebar.config \
	rebar.lock

publish: $(DESTDIR) $(ARTIFACTS)
	@cp -r $(ARTIFACTS) $(DESTDIR)

$(DESTDIR):
	@mkdir -p $@
