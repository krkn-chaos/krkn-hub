# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /home/krkn/.kube/config

# Copy configurations
COPY env.sh /home/krkn/main_env.sh
COPY chaos-recommender/run.sh /home/krkn/run.sh
COPY chaos-recommender/env.sh /home/krkn/env.sh
COPY common_run.sh /home/krkn/common_run.sh

ENTRYPOINT /home/krkn/run.sh
