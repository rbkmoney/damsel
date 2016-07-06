SHELL := /bin/bash

which = $(if $(shell which $(1) 2>/dev/null),\
	$(shell which $(1) 2>/dev/null),\
	$(error "Error: could not locate $(1)!"))

DOCKER_COMPOSE = $(call which,docker-compose)

UTIL_TARGETS := run_w_container_% check_w_container_%

run_w_container_%: check_w_container_%
	{ \
	$(DOCKER_COMPOSE) up -d ; \
	$(DOCKER_COMPOSE) exec -T $(RELNAME) make $(subst run_w_container_,,$@) ; \
	res=$$? ; \
	$(DOCKER_COMPOSE) down ; \
	exit $$res ; \
	}

check_w_container_%: TARG = $(subst check_w_container_,,$@)
check_w_container_%:
	$(if $(filter $(TARG),$(CALL_W_CONTAINER)),,\
	$(error "Error: target '$(TARG)' cannot be called w_container_"))