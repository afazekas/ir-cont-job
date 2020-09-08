CONTAINER_PREFIX=ir
.DEFAULT_GOAL := state/${CONTAINER_PREFIX}-infrared
.PHONY: all clean push
.SECONDRAY:

state/${CONTAINER_PREFIX}-base: $(wildcard  containers/base/*)
	cd containers/base; buildah build-using-dockerfile -f Dockerfile  -t ${CONTAINER_PREFIX}-base:latest
	touch $@

state/${CONTAINER_PREFIX}-py: $(wildcard  containers/py/*) state/${CONTAINER_PREFIX}-base
	cd containers/py; buildah build-using-dockerfile -f Dockerfile  -t ${CONTAINER_PREFIX}-py:latest
	touch $@

state/${CONTAINER_PREFIX}-infrared: $(wildcard  containers/infrared/*) state/${CONTAINER_PREFIX}-py
	cd containers/infrared; buildah build-using-dockerfile -f Dockerfile -t ${CONTAINER_PREFIX}-infrared:latest
	touch $@

state/${CONTAINER_PREFIX}-go: $(wildcard  containers/go/*) state/${CONTAINER_PREFIX}-base
	cd containers/go; buildah build-using-dockerfile -f Dockerfile  -t ${CONTAINER_PREFIX}-go:latest
	touch $@

state/${CONTAINER_PREFIX}-docker_distribution: $(wildcard  containers/docker_distribution/*) state/${CONTAINER_PREFIX}-go
	cd containers/docker_distribution; buildah build-using-dockerfile -f Dockerfile  -t ${CONTAINER_PREFIX}-docker_distribution:latest
	touch $@

state/${CONTAINER_PREFIX}-java: $(wildcard  containers/java/*) state/${CONTAINER_PREFIX}-base
	cd containers/java; buildah build-using-dockerfile -f Dockerfile -t ${CONTAINER_PREFIX}-java:latest
	touch $@

state/${CONTAINER_PREFIX}-jenkins_base: $(wildcard containers/jenkins_base/*) state/${CONTAINER_PREFIX}-java
	cd containers/jenkins_base; buildah build-using-dockerfile -f Dockerfile -t ${CONTAINER_PREFIX}-jenkins_base:latest
	touch $@

state/${CONTAINER_PREFIX}-jenkins_plugins: $(wildcard containers/jenkins_plugins/*) state/${CONTAINER_PREFIX}-jenkins_base
	cd containers/jenkins_plugins; buildah build-using-dockerfile -f Dockerfile -t ${CONTAINER_PREFIX}-jenkins_plugins:latest
	touch $@

state/${CONTAINER_PREFIX}-jjb: $(wildcard containers/jjb/*) state/${CONTAINER_PREFIX}-py
	cd containers/jjb; buildah build-using-dockerfile -f Dockerfile -t ${CONTAINER_PREFIX}-jjb:latest
	touch $@

state/${CONTAINER_PREFIX}-dlrnapi: $(wildcard containers/dlrnapi/*) state/${CONTAINER_PREFIX}-py
	cd containers/dlrnapi ;buildah build-using-dockerfile -f Dockerfile  -t ${CONTAINER_PREFIX}-dlrnapi:latest
	touch $@

TAG ?= latest

state/registry:
	mkdir -p $@

# To push use:
# podman login ...
# TAG=testing REGISTRY=myregistry/my_reg_prefix make push
# TAG=testing REGISTRY=myregistry\\:5000/my_reg_prefix make push

state/registry/${REGISTRY}:
	mkdir -p $@

state/registry/${REGISTRY}/${TAG}:
	mkdir -p $@

state/registry/${REGISTRY}/${TAG}/${CONTAINER_PREFIX}-%: state/registry/${REGISTRY}/${TAG} state/${CONTAINER_PREFIX}-%
	podman tag $(notdir $@) $(patsubst \:,:,${REGISTRY})/$(notdir $@):${TAG}
	podman push $(patsubst \:,:,${REGISTRY})/$(notdir $@):${TAG}
	touch $@

state/registry/${REGISTRY}.${TAG}.done: $(addprefix state/registry/${REGISTRY}/${TAG}/${CONTAINER_PREFIX}-,$(notdir $(wildcard containers/*)))
	touch $@

all:  $(addprefix state/${CONTAINER_PREFIX}-,$(notdir $(wildcard containers/*)))

push: state/registry/${REGISTRY}.${TAG}.done

clean:
	-rm state/${CONTAINER_PREFIX}-base
