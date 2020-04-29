
CONTAINER_PREFIX=ir
.DEFAULT_GOAL := state/${CONTAINER_PREFIX}-infrared

state/${CONTAINER_PREFIX}-base:  containers/base/Dockerfile
	buildah build-using-dockerfile -f $<  -t ${CONTAINER_PREFIX}-base:latest
	touch $@

state/${CONTAINER_PREFIX}-py:  containers/py/Dockerfile state/${CONTAINER_PREFIX}-base
	buildah build-using-dockerfile -f $<  -t ${CONTAINER_PREFIX}-py:latest
	touch $@

state/${CONTAINER_PREFIX}-infrared:  containers/infrared/Dockerfile state/${CONTAINER_PREFIX}-py
	buildah build-using-dockerfile -f $<  -t ${CONTAINER_PREFIX}-infrared:latest
	touch $@

state/${CONTAINER_PREFIX}-go:  containers/go/Dockerfile state/${CONTAINER_PREFIX}-base
	buildah build-using-dockerfile -f $<  -t ${CONTAINER_PREFIX}-go:latest
	touch $@

state/${CONTAINER_PREFIX}-java:  containers/java/Dockerfile state/${CONTAINER_PREFIX}-base
	buildah build-using-dockerfile -f $<  -t ${CONTAINER_PREFIX}-java:latest
	touch $@

all: state/${CONTAINER_PREFIX}-infrared state/${CONTAINER_PREFIX}-go state/${CONTAINER_PREFIX}-java

clean:
	-rm state/${CONTAINER_PREFIX}-base


