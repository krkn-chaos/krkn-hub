# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /tmp/.kube/config

# Install dependencies
RUN yum install -y which
RUN pip install jsonschema

# Copy configurations
COPY config.yaml.template /tmp/kraken/config/config.yaml.template
COPY service-hijacking/env.sh /tmp/env.sh
COPY service-hijacking/run.sh /tmp/run.sh
COPY env.sh /tmp/main_env.sh


COPY service-hijacking/config-schema.json /tmp/kraken/scenarios/service-hijacking-schema.json
COPY service-hijacking/validate_config.py /tmp/validate_config.py

COPY common_run.sh /tmp/common_run.sh

ENTRYPOINT /tmp/run.sh
