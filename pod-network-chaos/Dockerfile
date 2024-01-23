# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY config.yaml.template /root/kraken/config/config.yaml.template
COPY metrics_config.yaml.template /root/kraken/config/kube_burner.yaml.template
COPY pod-network-chaos/env.sh /root/env.sh
COPY env.sh /root/main_env.sh
COPY pod-network-chaos/run.sh /root/run.sh
COPY common_run.sh /root/common_run.sh
COPY pod-network-chaos/pod_network_scenario.yaml.template /root/kraken/scenarios/pod_network_scenario.yaml.template

ENTRYPOINT /root/run.sh
