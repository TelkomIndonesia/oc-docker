FROM alpine:3.18.4 AS oc

ARG TARGETARCH
WORKDIR /workspace
RUN \
    wget -nv "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux-${TARGETARCH}.tar.gz" -O oc.tar.gz  \
    || wget -nv "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz" -O oc.tar.gz
RUN tar -xzf oc.tar.gz



FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

COPY --from=docker:cli /usr/local/bin/docker /usr/local/bin/docker
COPY --from=ghcr.io/jqlang/jq /jq /usr/local/bin/jq
COPY --from=mikefarah/yq /usr/bin/yq /usr/local/bin/yq
COPY --from=hashicorp/vault /bin/vault /usr/local/bin/vault
COPY --from=hashicorp/consul-template /bin/consul-template /usr/local/bin/consul-template
COPY --from=oc /workspace/oc /usr/local/bin/oc
