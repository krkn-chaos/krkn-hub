# Dockerfile for kraken

FROM quay.io/chaos-kubox/krkn:latest

LABEL Red Hat Chaos Engineering Team

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY config.yaml.template /root/kraken/config/config.yaml.template
COPY metrics_config.yaml.template /root/kraken/config/kube_burner.yaml.template
COPY pvc-scenario/env.sh /root/env.sh
COPY env.sh /root/main_env.sh
COPY pvc-scenario/run.sh /root/run.sh
COPY common_run.sh /root/common_run.sh
COPY pvc-scenario/pvc_scenario.yaml.template /root/kraken/scenarios/pvc_scenario.yaml.template

ENTRYPOINT /root/run.sh
