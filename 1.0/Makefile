VERSION = 1.0
DOCKER_REPO = mirna-profiler

SHORT_HASH := $(shell git rev-parse --short HEAD)
DOCKER_URL := quay.io/ncigdc
DOCKER_IMAGE := ${DOCKER_URL}/${DOCKER_REPO}:${VERSION}
DOCKER_IMAGE_HASH := ${DOCKER_URL}/${DOCKER_REPO}:${VERSION}-${SHORT_HASH}

.PHONY: version name
name:
	@echo ${DOCKER_REPO}

version:
	@echo --- VERSION: ${VERSION} ---

.PHONY: docker-login
docker-login:
	@echo
	docker login -u=${QUAY_USERNAME} -p=${QUAY_PASSWORD} quay.io

.PHONY: build build-docker
build: build-docker

build-docker:
	@echo
	@echo -- Building docker --
	docker build . \
		--file ../Dockerfile.multi \
		--build-arg VERSION=${VERSION} \
		-t "${DOCKER_IMAGE}" \
		-t "${DOCKER_IMAGE_HASH}"

.PHONY: publish
publish: docker-login
	docker push ${DOCKER_IMAGE}
	docker push ${DOCKER_IMAGE_HASH}
