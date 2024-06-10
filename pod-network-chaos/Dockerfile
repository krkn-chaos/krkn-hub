# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /home/krkn/.kube/config

# Copy configurations
COPY config.yaml.template /home/krkn/kraken/config/config.yaml.template
COPY metrics_config.yaml.template /home/krkn/kraken/config/kube_burner.yaml.template
COPY pod-network-chaos/env.sh /home/krkn/env.sh
COPY env.sh /home/krkn/main_env.sh
COPY pod-network-chaos/run.sh /home/krkn/run.sh
COPY common_run.sh /home/krkn/common_run.sh
COPY pod-network-chaos/pod_network_scenario.yaml.template /home/krkn/kraken/scenarios/pod_network_scenario.yaml.template

ENTRYPOINT /home/krkn/run.sh
