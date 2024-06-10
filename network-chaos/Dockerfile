# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /home/krkn/.kube/config

# Copy configurations
COPY config.yaml.template /home/krkn/kraken/config/config.yaml.template
COPY metrics_config.yaml.template /home/krkn/kraken/config/kube_burner.yaml.template
COPY network-chaos/env.sh /home/krkn/env.sh
COPY env.sh /home/krkn/main_env.sh
COPY network-chaos/run.sh /home/krkn/run.sh
COPY common_run.sh /home/krkn/common_run.sh
COPY network-chaos/network_chaos_egress.yaml.template /home/krkn/kraken/scenarios/network_chaos_egress.yaml.template
COPY network-chaos/network_chaos_ingress.yaml.template /home/krkn/kraken/scenarios/network_chaos_ingress.yaml.template

ENTRYPOINT /home/krkn/run.sh
