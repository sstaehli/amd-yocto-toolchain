SHELL = bash

VERSION=2025.2
REGISTRY=gitlab-registry.airhead.ch
YEAR=$(shell echo $(VERSION) | cut -d. -f1)

DISTRO := ubuntu:22.04

.PHONY: default
default: help

.PHONY: all
all: create_image push_image
	docker system prune

.PHONY: create_image
create_image: create_base_image create_custom_image

.PHONY: create_base_image
create_base_image:
	mkdir -p build
	docker build \
	--file ./Dockerfile.Base \
	--build-arg DISTRO=$(DISTRO) \
	--build-arg VIVADO_VERSION=$(VERSION) \
	--tag build/amd-yocto-toolchain:$(VERSION)-base \
	--no-cache build/

.PHONY: create_custom_image
create_custom_image:
	cp entrypoint.sh build/
	docker build \
	--file ./Dockerfile.Custom \
	--build-arg VIVADO_VERSION=$(VERSION) \
	--tag build/amd-yocto-toolchain:$(VERSION) \
	--no-cache build/

.PHONY: push_image
push_image:
	@IMAGE_ID=$$(docker images --quiet build/amd-toolchain:$(VERSION)); \
	echo "Pushing image with image ID: $$IMAGE_ID"
	docker tag build/amd-yocto-toolchain:$(VERSION)-base $(REGISTRY)/containers/toolchains/amd-yocto-toolchain:$(VERSION)-base
	docker push $(REGISTRY)/containers/toolchains/amd-yoctotoolchain:$(VERSION)-base
	
.PHONY: clean
clean:
	docker rmi build/amd-toolchain:$(VERSION)-base || true
	rm -rf build

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all                 : Build all targets"
	@echo "  create_base_image   : Create Vivado base Docker image"
	@echo "  create_custom_image : Create custom Vivado Docker image"
	@echo "  push_image          : Push image to registry"