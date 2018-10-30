FROM alpine:3.8

ENV GOSS_VER v0.3.6
ENV KUBECTL_VER v1.12.2
ENV PATH=/goss:$PATH

# Install goss
RUN apk add --no-cache curl ca-certificates && \
    mkdir /goss && \
    curl -fsSL https://goss.rocks/install | GOSS_DST=/goss sh 

# setup kubectl
RUN curl -Lo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VER/bin/linux/amd64/kubectl && \
    chmod 755 /usr/bin/kubectl && \
    kubectl config set-cluster local --server=https://kubernetes.default --certificate-authority=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt && \
    kubectl config set-context local --cluster=local --user=goss && \
    kubectl config use-context local

VOLUME /goss

# Easily add healtchecks to your image
# COPY goss/ /goss/
# HEALTHCHECK --interval=1s --timeout=6s CMD goss -g /goss/goss.yaml validate
