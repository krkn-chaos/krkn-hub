# Dockerfile for kraken

FROM quay.io/redhat-chaos/krkn:latest

MAINTAINER Red Hat Chaos Engineering Team

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY config.yaml.template /root/kraken/config/config.yaml.template
COPY metrics_config.yaml.template /root/kraken/config/kube_burner.yaml.template
COPY pod-scenarios/env.sh /root/env.sh
COPY env.sh /root/main_env.sh
COPY pod-scenarios/run.sh /root/run.sh
COPY common_run.sh /root/common_run.sh
COPY pod-scenarios/pod_scenario.yaml.template /root/kraken/scenarios/pod_scenario.yaml.template
COPY pod-scenarios/pod_scenario_namespace.yaml.template /root/kraken/scenarios/pod_scenario_namespace.yaml.template

ENTRYPOINT /root/run.sh
