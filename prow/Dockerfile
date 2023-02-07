# Dockerfile for krkn-hub in prow

FROM registry.ci.openshift.org/chaos/krkn:latest as krkn

LABEL maintainer="Red Hat Chaos Engineering Team"

# Install dependencies
RUN yum install -y which

# Copy configurations
ADD . /krkn-hub

RUN yum install -y python3 python3-pip python3-devel git diffutils && python3 -m pip install --upgrade pip

ENV PYTHONPATH=/krkn-hub/packages:$PYTHONPATH PYTHONUNBUFFERED=1

RUN ls

WORKDIR /krkn-hub