# Dockerfile for kraken

FROM quay.io/openshift-scale/kraken:latest

MAINTAINER Red Hat Chaos Engineering Team

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY container-scenarios/config.yaml.template /root/kraken/config/config.yaml.template
COPY container-scenarios/env.sh /root/env.sh
COPY container-scenarios/run.sh /root/run.sh
COPY container-scenarios/container_scenario.yaml.template /root/kraken/scenarios/container_scenario.yaml.template
COPY common_run.sh /root/common_run.sh

ENTRYPOINT /root/run.sh
