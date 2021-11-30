###
# Makefile to build and release Docker images used in our CI/CD build pipeline and deployments
###
.PHONY: help deps info shellcheck hadolint builder-instance oci login scan publish publish-force clean

.DEFAULT_GOAL := oci

SHELL                    := /usr/bin/bash
PROJECT_DIR              := $(shell basename $(abspath $(dir $$PWD)))
CONTAINER_REGISTRY       ?=
CONTAINER_REGISTRY_REPO  ?=
CONTAINER_REGISTRY_LOGIN ?=
CONTAINER_REGISTRY_PASS  ?=
BUILD_VERSION_SUFFIX     ?=
RELEASE_TAG              ?= $(shell cat release.tag)$(BUILD_VERSION_SUFFIX)
SINGLE_ARCH              ?= linux/amd64
MULTI_ARCH               ?= linux/amd64
BUILDER_INSTANCE         ?= builder-$(PROJECT_DIR)
DOCKER_TAG               := $(CONTAINER_REGISTRY)/$(CONTAINER_REGISTRY_REPO)/$(RELEASE_TAG)

help:
	@echo ""
	@echo "Makefile to build Docker base container images"
	@echo ""
	@echo "Targets:"
	@echo "  help:             Show this help."
	@echo ""
	@echo "  deps:             Verify if dependencies to build container images are available."
	@echo ""
	@echo "  Dockerfile:       Generate Dockerfile for the project for local build and development."
	@echo ""
	@echo "  builder-instance: Create a buildx instance for this project or reuse an existing one."
	@echo ""
	@echo "  oci:              Build a local OCI image for a single target architecture for a project."
	@echo "                    You can specify the target architecture with SINGLE_ARCH."
	@echo "                    The default is set to $(SINGLE_ARCH)."
	@echo ""
	@echo "  login:            Login ot the container registry with CONTAINER_REGISTRY, CONTAINER_REGISTRY_LOGIN and CONTAINER_REGISTRY_PASS."
	@echo ""
	@echo "  scan:             Vulnerability scan for a local single architecture build using snyke."
	@echo "                    INFO: As an unregistered user you have 10 scans for free, a registered free plan has 200 container tests per month."
	@echo ""
	@echo "  publish:          Builds the project and pushes it to a registry. You can build multiple architectures"
	@echo "                    using the MULTI_ARCH parameter. Pushing to a registry allows you to build a manifest"
	@echo "                    with multiple architectures for a single tag, you can set MULTI_ARCH to"
	@echo "                    "linux/amd64,linux/arm64,linux/arm/v7" if you want. The default is set to $(MULTI_ARCH)."
	@echo "                    Make sure you publish a tag which doesn't exist by setting a release.version."
	@echo "                    Prefer treating published tags as immutable to avoid impact in CI/CD and production pipelines."
	@echo ""
	@echo "  publish-force:    We prevent overwriting an existing image tag in a registry wh. The publish-force target allows you"
	@echo "                    to overwrite an already published image tag."
	@echo "                    WARNING: Changing an image tag can has some consequences in production and CI/CD pipelines."
	@echo "                    Be aware you can break things here for other people."
	@echo ""
	@echo "  clean:            Remove all build artifacts, i.e. Dockerfile, builder instance and OCI images in the build directory."
	@echo ""

deps:
	@command -v envsubst;
	@command -v docker;
	@command -v shellcheck;
	@command -v hadolint;

info: deps
	@echo ""
	@docker --version
	@echo "Image Tag: $(DOCKER_TAG)"
	@echo ""

shellcheck: deps
	@echo -n "Run shellcheck: "
	@find . -type f -name '*.sh' | xargs shellcheck --external-sources -e SC2034,SC2155
	@echo -e "\033[0;32mDONE\033[0m"

hadolint: deps
	@echo -n "Run Hadolint on all Dockerfile templates: "
	@find . -type f -name 'Dockerfile.tpl' | xargs hadolint --ignore=DL3059
	@echo -e "\033[0;32mDONE\033[0m"

Dockerfile: shellcheck hadolint info
	@echo -n "Generating Dockerfile: "
	@source ./version-lock.sh && envsubst < "Dockerfile.tpl" > "Dockerfile"
	@echo -e "\033[0;32mDONE\033[0m"

builder-instance: info
	@if ! docker context inspect "$(BUILDER_INSTANCE)"; then docker context create "$(BUILDER_INSTANCE)"; fi;
	docker context use "$(BUILDER_INSTANCE)"
	
oci: Dockerfile builder-instance
	docker buildx build -o type=docker --platform="$(SINGLE_ARCH)" --tag $(PROJECT_DIR):$(subst /,-,$(SINGLE_ARCH)) .
	docker image save $(PROJECT_DIR) -o ./build/$(PROJECT_DIR)_$(subst /,-,$(SINGLE_ARCH)).oci
	@echo "Artifact for architecture $(SINGLE_ARCH): ./build/$(PROJECT_DIR)_$(subst /,-,$(SINGLE_ARCH)).oci"

login: deps
	@echo -n "Login to ${CONTAINER_REGISTRY}: "
	@echo "${CONTAINER_REGISTRY_PASS}" | docker login ${CONTAINER_REGISTRY} -u "${CONTAINER_REGISTRY_LOGIN}" --password-stdin > /dev/null
	@echo -e "\033[0;32mDONE\033[0m"

scan: oci
	@echo "Vulnerability scan for $(PROJECT_DIR):$(subst /,-,$(SINGLE_ARCH))"
	docker scan --dependency-tree $(PROJECT_DIR):$(subst /,-,$(SINGLE_ARCH))

publish: info Dockerfile builder-instance login
	@echo -n "Verify image tag in registry for $(DOCKER_TAG): "
	@if docker manifest inspect "$(DOCKER_TAG)" >/dev/null; then echo -e "\033[0;31mFAIL\033[0m - Image tag already published on registry."; exit 1; fi;
	@echo -e "\033[0;32mDONE\033[0m"
	docker buildx build -o type=registry --platform="$(MULTI_ARCH)" --tag "$(DOCKER_TAG)" .

publish-force: info Dockerfile builder-instance login
	@echo -e "\033[0;31mWarning!\033[0m You want to force push a docker image to a registry."
	@echo "Force push and overwrite existing tag: $(DOCKER_TAG)"
	@echo ""
	@echo -n "Are you sure? [y/N] " && read ans && [ $${ans:-N} == y ]
	docker buildx build -o type=registry --platform="$(MULTI_ARCH)" --tag "$(DOCKER_TAG)" .

clean: deps
	@echo -n "Remove generated Dockerfile: "
	@rm -f Dockerfile
	@echo -e "\033[0;32mDONE\033[0m"
	@echo -n "Remove OCI build artifacts:  "
	@rm -rf ./build/*.oci
	@echo -e "\033[0;32mDONE\033[0m"
	@echo -n "Remove Builder instance:     "
	@if docker buildx inspect "$(BUILDER_INSTANCE)" >/dev/null 2>&1; then docker buildx rm "$(BUILDER_INSTANCE)"; echo -e "\033[0;32mDONE\033[0m"; else echo "SKIPPED"; fi;
