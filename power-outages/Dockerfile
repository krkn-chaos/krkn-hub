# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /tmp/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY config.yaml.template /tmp/kraken/config/config.yaml.template
COPY metrics_config.yaml.template /tmp/kraken/config/kube_burner.yaml.template
COPY power-outages/env.sh /tmp/env.sh
COPY env.sh /tmp/main_env.sh
COPY power-outages/run.sh /tmp/run.sh
COPY power-outages/shutdown_scenario.yaml.template /tmp/kraken/scenarios/shutdown_scenario.yaml.template
COPY power-outages/post_action.py /tmp/kraken/scenarios/post_action.py
COPY common_run.sh /tmp/common_run.sh

ENTRYPOINT /tmp/run.sh
