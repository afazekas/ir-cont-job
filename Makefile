
CONTAINER_PREFIX=ir
.DEFAULT_GOAL := state/infrared

state/base:  containers/base/Dockerfile
	buildah build-using-dockerfile -f $<  -t ${CONTAINER_PREFIX}-base:latest
	touch $@

state/py:  containers/py/Dockerfile state/base
	buildah build-using-dockerfile -f $<  -t ${CONTAINER_PREFIX}-py:latest
	touch $@

state/infrared:  containers/infrared/Dockerfile state/py
	buildah build-using-dockerfile -f $<  -t ${CONTAINER_PREFIX}-infrared:latest
	touch $@

state/go:  containers/go/Dockerfile state/base
	buildah build-using-dockerfile -f $<  -t ${CONTAINER_PREFIX}-go:latest
	touch $@

state/java:  containers/java/Dockerfile state/base
	buildah build-using-dockerfile -f $<  -t ${CONTAINER_PREFIX}-java:latest
	touch $@



