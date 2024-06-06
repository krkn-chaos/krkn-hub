# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /tmp/.kube/config

# Install dependencies
RUN yum install -y which wget
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq
# Copy configurations
COPY metrics_config.yaml.template /tmp/kraken/config/kube_burner.yaml.template
COPY config.yaml.template /tmp/kraken/config/config.yaml.template
COPY node-cpu-hog/env.sh /tmp/env.sh
COPY env.sh /tmp/main_env.sh
COPY node-cpu-hog/run.sh /tmp/run.sh
COPY node-cpu-hog/input.yaml.template /tmp/kraken/scenarios/arcaflow/cpu-hog/input.yaml.template
COPY common_run.sh /tmp/common_run.sh

ENTRYPOINT /tmp/run.sh
