.PHONY: deps shellcheck hadolint

.DEFAULT_GOAL := shellcheck

SHELL             := bash
.ONESHELL:
.SHELL_FLAGS      := -o nounset -o pipefail -o errexit

deps:
	@command -v shellcheck
	@command -v hadolint

shellcheck: deps
	@echo -n "Run shellcheck for all projects: "
	@find . -type f -name '*.sh' | xargs shellcheck --external-sources -e SC2034,SC2155

hadolint: deps
	@echo -n "Run Hadolint on all Dockerfile templates: "
	@find . -type f -name 'Dockerfile.tpl' | xargs hadolint
