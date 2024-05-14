# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which
RUN pip install jsonschema

# Copy configurations
COPY config.yaml.template /root/kraken/config/config.yaml.template
COPY service-hijacking/env.sh /root/env.sh
COPY service-hijacking/run.sh /root/run.sh
COPY env.sh /root/main_env.sh


COPY service-hijacking/config-schema.json /root/kraken/scenarios/service-hijacking-schema.json
COPY service-hijacking/validate_config.py /root/validate_config.py

COPY common_run.sh /root/common_run.sh

ENTRYPOINT /root/run.sh
