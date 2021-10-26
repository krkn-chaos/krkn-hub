# Dockerfile for kraken

FROM quay.io/openshift-scale/kraken:latest

MAINTAINER Red Hat Chaos Engineering Team

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY cluster-shutdown/config.yaml.template /root/kraken/config/config.yaml.template
COPY cluster-shutdown/env.sh /root/env.sh
COPY cluster-shutdown/run.sh /root/run.sh
COPY cluster-shutdown/shutdown_scenario.yaml.template /root/kraken/scenarios/shutdown_scenario.yaml.template
COPY common_run.sh /root/common_run.sh

ENTRYPOINT /root/run.sh
