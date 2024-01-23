# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY config.yaml.template /root/kraken/config/config.yaml.template
COPY metrics_config.yaml.template /root/kraken/config/kube_burner.yaml.template
COPY service-disruption-scenarios/env.sh /root/env.sh
COPY env.sh /root/main_env.sh
COPY service-disruption-scenarios/run.sh /root/run.sh
COPY service-disruption-scenarios/namespace_scenario.yaml.template /root/kraken/scenarios/namespace_scenario.yaml.template
COPY common_run.sh /root/common_run.sh

ENTRYPOINT /root/run.sh
