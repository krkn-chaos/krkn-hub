# Dockerfile for cerberus

FROM quay.io/openshift-scale/cerberus:latest

MAINTAINER Red Hat Chaos Engineering Team

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which gettext

# Copy configurations
COPY env.sh /root/env.sh
COPY run.sh /root/run.sh
COPY cerberus.yaml.template /root/cerberus/config/cerberus.yaml.template

ENTRYPOINT /root/run.sh
