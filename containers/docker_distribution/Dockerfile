FROM ir-go AS build

ENV DISTRIBUTION_DIR /go/src/github.com/docker/distribution
ENV BUILDTAGS include_oss include_gcs

ARG GOOS=linux
ARG GOARCH=amd64
ARG GOARM=6
ARG VERSION
ARG REVISION

WORKDIR $DISTRIBUTION_DIR
RUN git clone http://github.com/docker/distribution $DISTRIBUTION_DIR
# TODO: version pinning
RUN CGO_ENABLED=0 make PREFIX=/go clean binaries && file ./bin/registry | grep "statically linked"

FROM ir-base

RUN set -ex \
    && yum install -y httpd-tools

# Config needs to be binded at /etc/docker/registry/config.yml
# Default noauth registry (use ro volume or for local only dev)
# Most config option is passable as environement variable.
COPY config-noauth.yml /etc/docker/registry/config.yml
COPY --from=build /go/src/github.com/docker/distribution/bin/registry /bin/registry
EXPOSE 5000
ENTRYPOINT ["registry"]
CMD ["serve", "/etc/docker/registry/config.yml"]
