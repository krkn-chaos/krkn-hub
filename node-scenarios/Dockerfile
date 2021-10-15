# Dockerfile for kraken

FROM quay.io/openshift-scale/kraken:latest

MAINTAINER Red Hat Chaos Engineering Team

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY node-scenarios/config.yaml.template /root/kraken/config/config.yaml.template
COPY node-scenarios/env.sh /root/env.sh
COPY node-scenarios/run.sh /root/run.sh
COPY common_run.sh /root/common_run.sh
COPY node-scenarios/node_scenario.yaml.template /root/kraken/scenarios/node_scenario.yaml.template

ENTRYPOINT /root/run.sh
