# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /tmp/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY config.yaml.template /tmp/kraken/config/config.yaml.template
COPY metrics_config.yaml.template /tmp/kraken/config/kube_burner.yaml.template
COPY pod-network-chaos/env.sh /tmp/env.sh
COPY env.sh /tmp/main_env.sh
COPY pod-network-chaos/run.sh /tmp/run.sh
COPY common_run.sh /tmp/common_run.sh
COPY pod-network-chaos/pod_network_scenario.yaml.template /tmp/kraken/scenarios/pod_network_scenario.yaml.template

ENTRYPOINT /tmp/run.sh
