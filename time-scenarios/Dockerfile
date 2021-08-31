# Dockerfile for kraken

FROM quay.io/openshift-scale/kraken:latest

MAINTAINER Red Hat Chaos Engineering Team

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY config.yaml.template /root/kraken/config/config.yaml.template
COPY env.sh /root/env.sh
COPY run.sh /root/run.sh
COPY time_scenario.yaml.template /root/kraken/scenarios/time_scenario.yaml.template

ENTRYPOINT /root/run.sh
