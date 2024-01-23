# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which wget
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq
# Copy configurations
COPY env.sh /root/main_env.sh
COPY chaos-recommender/run.sh /root/run.sh
COPY chaos-recommender/env.sh /root/env.sh
COPY common_run.sh /root/common_run.sh

ENTRYPOINT /root/run.sh
