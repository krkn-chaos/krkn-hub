# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /home/krkn/.kube/config

# Copy configurations
COPY config.yaml.template /home/krkn/kraken/config/config.yaml.template
COPY metrics_config.yaml.template /home/krkn/kraken/config/kube_burner.yaml.template
COPY application-outages/env.sh /home/krkn/env.sh
COPY env.sh /home/krkn/main_env.sh
COPY application-outages/run.sh /home/krkn/run.sh
COPY common_run.sh /home/krkn/common_run.sh
COPY application-outages/app_outages.yaml.template /home/krkn/kraken/scenarios/app_outage.yaml.template

ENTRYPOINT /home/krkn/run.sh
