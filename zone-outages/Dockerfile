# Dockerfile for kraken

FROM quay.io/openshift-scale/kraken:latest

MAINTAINER Red Hat Chaos Engineering Team

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY zone-outages/config.yaml.template /root/kraken/config/config.yaml.template
COPY zone-outages/env.sh /root/env.sh
COPY zone-outages/run.sh /root/run.sh
COPY zone-outages/zone_outage_scenario.yaml.template /root/kraken/scenarios/zone_outage_scenario.yaml.template
COPY common_run.sh /root/common_run.sh

ENTRYPOINT /root/run.sh
