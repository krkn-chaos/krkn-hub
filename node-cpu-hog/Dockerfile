# Dockerfile for kraken

FROM quay.io/redhat-chaos/krkn:latest

MAINTAINER Red Hat Chaos Engineering Team

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which wget
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq
# Copy configurations
COPY metrics_config.yaml.template /root/kraken/config/kube_burner.yaml.template
COPY config.yaml.template /root/kraken/config/config.yaml.template
COPY node-cpu-hog/env.sh /root/env.sh
COPY env.sh /root/main_env.sh
COPY node-cpu-hog/run.sh /root/run.sh
COPY node-cpu-hog/input.yaml.template /root/kraken/scenarios/arcaflow/cpu-hog/input.yaml.template
COPY common_run.sh /root/common_run.sh

ENTRYPOINT /root/run.sh
