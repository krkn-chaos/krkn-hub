# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /home/krkn/.kube/config

# Copy configurations
COPY config.yaml.template /home/krkn/kraken/config/config.yaml.template
COPY service-hijacking/env.sh /home/krkn/env.sh
COPY service-hijacking/run.sh /home/krkn/run.sh
COPY env.sh /home/krkn/main_env.sh


COPY service-hijacking/config-schema.json /home/krkn/kraken/scenarios/service-hijacking-schema.json
COPY service-hijacking/validate_config.py /home/krkn/validate_config.py

COPY common_run.sh /home/krkn/common_run.sh

ENTRYPOINT /home/krkn/run.sh
