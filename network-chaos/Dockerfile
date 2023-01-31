# Dockerfile for kraken

FROM quay.io/redhat-chaos/krkn:latest

MAINTAINER Red Hat Chaos Engineering Team

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY config.yaml.template /root/kraken/config/config.yaml.template
COPY metrics_config.yaml.template /root/kraken/config/kube_burner.yaml.template
COPY network-chaos/env.sh /root/env.sh
COPY env.sh /root/main_env.sh
COPY network-chaos/run.sh /root/run.sh
COPY common_run.sh /root/common_run.sh
COPY network-chaos/network_chaos_egress.yaml.template /root/kraken/scenarios/network_chaos_egress.yaml.template
COPY network-chaos/network_chaos_ingress.yaml.template /root/kraken/scenarios/network_chaos_ingress.yaml.template

ENTRYPOINT /root/run.sh
