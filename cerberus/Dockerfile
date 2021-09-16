# Dockerfile for cerberus

FROM quay.io/openshift-scale/cerberus:latest

MAINTAINER Red Hat Chaos Engineering Team

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which gettext

# Copy configurations
COPY cerberus/env.sh /root/env.sh
COPY cerberus/run.sh /root/run.sh
COPY cerberus/cerberus.yaml.template /root/cerberus/config/cerberus.yaml.template
COPY common_run.sh /root/common_run.sh

ENTRYPOINT /root/run.sh
