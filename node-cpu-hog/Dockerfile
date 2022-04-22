# Dockerfile for kraken

FROM quay.io/chaos-kubox/krkn:latest

MAINTAINER Red Hat Chaos Engineering Team

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY config.yaml.template /root/kraken/config/config.yaml.template
COPY metrics_config.yaml.template /root/kraken/config/kube_burner.yaml.template
COPY node-cpu-hog/env.sh /root/env.sh
COPY env.sh /root/main_env.sh
COPY node-cpu-hog/run.sh /root/run.sh
COPY node-cpu-hog/cpu_hog.yaml.template /root/kraken/scenarios/cpu_hog.yaml.template
COPY common_run.sh /root/common_run.sh

ENTRYPOINT /root/run.sh
