MAKEFLAGS += --warn-undefined-variables --no-print-directory
SHELL := /bin/bash

# TODO(jxson): Add appropriate PATH based on deps/tools.

.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

DIRNAME := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
DEPS_DIR := third_party

################################################################################
## Common variables to use
gitbook = $(shell which gitbook)

JS_FILES = $(shell find . -name "*.js" ! -wholename "./$(DEPS_DIR)/*" ! -wholename "*/node_modules/*")
SH_FILES = $(shell find ./tools -name "*.sh")
ALL_SOURCE_FILES = $(JS_FILES) $(SH_FILES)

################################################################################
## Common targets
.PHONY:
all: ## Default task to build dependencies.
	@true

# SEE: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help: ## Displays this help message.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: init
init: ## Set path to pick up deps with: eval $(make init)
	@echo "export PATH=${PATH}"

.PHONY: build
build:
	@true

.PHONY: clean
clean:
	@true

.PHONY: copyright-check
copyright-check: ## Run the copyright checker.
	@echo "** Checking the copyright headers ..."
	@export COPYRIGHT_ERROR=false; \
	for sf in $(ALL_SOURCE_FILES); do \
		echo $${sf}; \
		if ! $$(tools/copyright_check.sh $${sf}); then \
			export COPYRIGHT_ERROR=true; \
			echo "Invalid copyright header: '$${sf}'"; \
		fi; \
	done; \
	if [ "$${COPYRIGHT_ERROR}" = true ]; then \
		exit 1; \
	fi

.PHONY: fmt
fmt:
	@true

.PHONY: lint
lint:
	@true

# TODO(youngseokyoon): integrate this with the CI system later.
.PHONY: presubmit
presubmit: ## Run the presubmit tests.
	@$(MAKE) copyright-check

.PHONY: test
test:
	@true

.PHONY: coverage
coverage:
	@true

.PHONY: run
run:
	@true

# TODO(jxson): Add gitbook as a third-party dependency.
.PHONY: doc
doc:
	@if [ -f "$(gitbook)" ]; then \
		gitbook install; \
		gitbook serve; \
	else \
		echo "The gitbook tool is required to view docs locally."; \
		echo ""; \
		echo "Install gitbook with npm:"; \
		echo ""; \
		echo "    npm install -g gitbook-cli"; \
		echo ""; \
	fi; \
