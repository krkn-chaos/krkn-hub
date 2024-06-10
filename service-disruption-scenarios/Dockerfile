# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /home/krkn/.kube/config

# Copy configurations
COPY config.yaml.template /home/krkn/kraken/config/config.yaml.template
COPY metrics_config.yaml.template /home/krkn/kraken/config/kube_burner.yaml.template
COPY service-disruption-scenarios/env.sh /home/krkn/env.sh
COPY env.sh /home/krkn/main_env.sh
COPY service-disruption-scenarios/run.sh /home/krkn/run.sh
COPY service-disruption-scenarios/namespace_scenario.yaml.template /home/krkn/kraken/scenarios/namespace_scenario.yaml.template
COPY common_run.sh /home/krkn/common_run.sh

ENTRYPOINT /home/krkn/run.sh
