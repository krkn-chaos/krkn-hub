# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /home/krkn/.kube/config

# Copy configurations
COPY config.yaml.template /home/krkn/kraken/config/config.yaml.template
COPY metrics_config.yaml.template /home/krkn/kraken/config/kube_burner.yaml.template
COPY zone-outages/env.sh /home/krkn/env.sh
COPY env.sh /home/krkn/main_env.sh
COPY zone-outages/run.sh /home/krkn/run.sh
COPY zone-outages/zone_outage_scenario.yaml.template /home/krkn/kraken/scenarios/zone_outage_scenario.yaml.template
COPY common_run.sh /home/krkn/common_run.sh

ENTRYPOINT /home/krkn/run.sh
