
CONTAINER_PREFIX=ir
.DEFAULT_GOAL := state/${CONTAINER_PREFIX}-infrared

state/${CONTAINER_PREFIX}-base: $(wildcard  containers/base/*)
	buildah build-using-dockerfile -f $<  -t ${CONTAINER_PREFIX}-base:latest
	touch $@

state/${CONTAINER_PREFIX}-py: $(wildcard  containers/py/*) state/${CONTAINER_PREFIX}-base
	buildah build-using-dockerfile -f $<  -t ${CONTAINER_PREFIX}-py:latest
	touch $@

state/${CONTAINER_PREFIX}-infrared: $(wildcard  containers/infrared/*) state/${CONTAINER_PREFIX}-py
	buildah build-using-dockerfile -f $<  -t ${CONTAINER_PREFIX}-infrared:latest
	touch $@

state/${CONTAINER_PREFIX}-go: $(wildcard  containers/go/*) state/${CONTAINER_PREFIX}-base
	buildah build-using-dockerfile -f $<  -t ${CONTAINER_PREFIX}-go:latest
	touch $@

state/${CONTAINER_PREFIX}-java: $(wildcard  containers/java/*) state/${CONTAINER_PREFIX}-base
	buildah build-using-dockerfile -f $<  -t ${CONTAINER_PREFIX}-java:latest
	touch $@

state/${CONTAINER_PREFIX}-jenkins-base: $(wildcard containers/jenkins-base/*) state/${CONTAINER_PREFIX}-java
	cd containers/jenkins_base; buildah build-using-dockerfile -f Dockerfile -t ${CONTAINER_PREFIX}-jenkins-base:latest
	touch $@

state/${CONTAINER_PREFIX}-jjb: $(wildcard containers/jjb/*) state/${CONTAINER_PREFIX}-py
	buildah build-using-dockerfile -f $<  -t ${CONTAINER_PREFIX}-jjb:latest
	touch $@

state/${CONTAINER_PREFIX}-dlrnapi: $(wildcard containers/dlrnapi/*) state/${CONTAINER_PREFIX}-py
	buildah build-using-dockerfile -f $<  -t ${CONTAINER_PREFIX}-dlrnapi:latest
	touch $@

state/${CONTAINER_PREFIX}-jenkins-plugins: $(wildcard containers/enkins-plugins/*) state/${CONTAINER_PREFIX}-jenkins-base
	cd containers/jenkins_plugins; buildah build-using-dockerfile -f Dockerfile -t ${CONTAINER_PREFIX}-jenkins-plugins:latest
	touch $@


all: state/${CONTAINER_PREFIX}-infrared state/${CONTAINER_PREFIX}-go state/${CONTAINER_PREFIX}-jenkins-plugins state/${CONTAINER_PREFIX}-jjb state/${CONTAINER_PREFIX}-dlrnapi

clean:
	-rm state/${CONTAINER_PREFIX}-base


