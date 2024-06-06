# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /tmp/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY config.yaml.template /tmp/kraken/config/config.yaml.template
COPY metrics_config.yaml.template /tmp/kraken/config/kube_burner.yaml.template
COPY application-outages/env.sh /tmp/env.sh
COPY env.sh /tmp/main_env.sh
COPY application-outages/run.sh /tmp/run.sh
COPY common_run.sh /tmp/common_run.sh
COPY application-outages/app_outages.yaml.template /tmp/kraken/scenarios/app_outage.yaml.template

ENTRYPOINT /tmp/run.sh
