define get-ssh-remote-url
$(shell echo "$(1)" | sed -Ee 's|^https?://([a-z0-9.-]+)/(.+)/(.+)|git@\1:\2/\3|')
endef

GIT_REMOTE_NAME ?= origin
GIT_REPO_URL := $(call get-ssh-remote-url,$(shell git remote get-url $(GIT_REMOTE_NAME)))

GIT_HEAD_REF_NAME := $(shell git rev-parse --abbrev-ref HEAD)

ifneq ($(BRANCH_NAME),)
GIT_BRANCH := $(BRANCH_NAME)
else ifeq ($(GIT_HEAD_REF_NAME),HEAD)
GIT_BRANCH := $(shell git name-rev --name-only HEAD)
else
GIT_BRANCH := $(GIT_HEAD_REF_NAME)
endif

ifeq ($(GIT_BRANCH),master)
GIT_RELEASE_BRANCH := release
else
GIT_RELEASE_BRANCH := release/$(GIT_BRANCH)
endif

define get-commit-attr
git --no-pager log --pretty=format:"$(1)" -n 1
endef

GIT_COMMIT_HASH            := $(or $(COMMIT_ID),$(shell $(call get-commit-attr,"%h")))
GIT_COMMIT_AUTHOR_NAME     := $(or $(COMMIT_AUTHOR),$(shell $(call get-commit-attr,"%an")))
GIT_COMMIT_AUTHOR_EMAIL    := $(or $(COMMIT_AUTHOR_EMAIL),$(shell $(call get-commit-attr,"%ae")))

define clone-repo
( \
	git clone -q $(or $(1),$(GIT_REPO_URL)) $(REPODIR) \
)
endef

define checkout-or-create-release-branch
cd $(REPODIR) && ( \
	git checkout $(or $(1),$(GIT_RELEASE_BRANCH)) 2>/dev/null || ( \
		git checkout --orphan $(or $(1),$(GIT_RELEASE_BRANCH)) && \
		git reset --hard \
	) \
)
endef

define commit-release
cd $(REPODIR) && ( \
	git add -A . && \
	git config user.name  "$(or $(1),$(GIT_COMMIT_AUTHOR_NAME))" && \
	git config user.email "$(or $(2),$(GIT_COMMIT_AUTHOR_EMAIL))" && \
	git commit \
		--allow-empty \
		--message "$(or $(3),Release $(GIT_BRANCH) at $(GIT_COMMIT_HASH))" \
)
endef

define push-release
cd $(REPODIR) && ( \
	git push $(or $(2),$(GIT_REPO_URL)) $(or $(1),$(GIT_RELEASE_BRANCH)) \
)
endef
