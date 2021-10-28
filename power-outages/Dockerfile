# Dockerfile for kraken

FROM quay.io/openshift-scale/kraken:latest

MAINTAINER Red Hat Chaos Engineering Team

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY config.yaml.template /root/kraken/config/config.yaml.template
COPY power-outages/env.sh /root/env.sh
COPY env.sh /root/main_env.sh
COPY power-outages/run.sh /root/run.sh
COPY power-outages/shutdown_scenario.yaml.template /root/kraken/scenarios/shutdown_scenario.yaml.template
COPY common_run.sh /root/common_run.sh

ENTRYPOINT /root/run.sh