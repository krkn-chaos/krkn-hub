# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /tmp/.kube/config

# Install dependencies
RUN yum install -y which wget
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq
# Copy configurations
COPY env.sh /tmp/main_env.sh
COPY chaos-recommender/run.sh /tmp/run.sh
COPY chaos-recommender/env.sh /tmp/env.sh
COPY common_run.sh /tmp/common_run.sh

ENTRYPOINT /tmp/run.sh
