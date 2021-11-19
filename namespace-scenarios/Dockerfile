# Dockerfile for kraken

FROM quay.io/openshift-scale/kraken:latest

MAINTAINER Red Hat Chaos Engineering Team

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY config.yaml.template /root/kraken/config/config.yaml.template
COPY metrics_config.yaml.template /root/kraken/config/kube_burner.yaml.template
COPY namespace-scenarios/env.sh /root/env.sh
COPY env.sh /root/main_env.sh
COPY namespace-scenarios/run.sh /root/run.sh
COPY namespace-scenarios/namespace_scenario.yaml.template /root/kraken/scenarios/namespace_scenario.yaml.template
COPY common_run.sh /root/common_run.sh

ENTRYPOINT /root/run.sh
