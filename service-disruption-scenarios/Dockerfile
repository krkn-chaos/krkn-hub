# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /tmp/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY config.yaml.template /tmp/kraken/config/config.yaml.template
COPY metrics_config.yaml.template /tmp/kraken/config/kube_burner.yaml.template
COPY service-disruption-scenarios/env.sh /tmp/env.sh
COPY env.sh /tmp/main_env.sh
COPY service-disruption-scenarios/run.sh /tmp/run.sh
COPY service-disruption-scenarios/namespace_scenario.yaml.template /tmp/kraken/scenarios/namespace_scenario.yaml.template
COPY common_run.sh /tmp/common_run.sh

ENTRYPOINT /tmp/run.sh
