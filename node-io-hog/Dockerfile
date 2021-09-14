# Dockerfile for kraken

FROM quay.io/openshift-scale/kraken:latest

MAINTAINER Red Hat Chaos Engineering Team

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY node-io-hog/config.yaml.template /root/kraken/config/config.yaml.template
COPY node-io-hog/env.sh /root/env.sh
COPY node-io-hog/run.sh /root/run.sh
COPY node-io-hog/io_hog.yaml.template /root/kraken/scenarios/io_hog.yaml.template
COPY common_run.sh /root/common_run.sh

ENTRYPOINT /root/run.sh
