# Dockerfile for kraken

FROM quay.io/openshift-scale/kraken:latest

MAINTAINER Red Hat Chaos Engineering Team

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY time-scenarios/config.yaml.template /root/kraken/config/config.yaml.template
COPY time-scenarios/env.sh /root/env.sh
COPY time-scenarios/run.sh /root/run.sh
COPY time-scenarios/time_scenario.yaml.template /root/kraken/scenarios/time_scenario.yaml.template
COPY common_run.sh /root/common_run.sh

ENTRYPOINT /root/run.sh
