FROM fedora@sha256:3c86d25fef9d2001712bc3d9b091fc40cf04be4767e48f1aa3b785bf58d300ed
ARG TARGETARCH
ENV VEGETA_VERSION=12.13.0
RUN dnf update -y && dnf install --setopt=install_weak_deps=False -y tar gzip && dnf clean all
RUN curl -L https://github.com/tsenart/vegeta/releases/download/v${VEGETA_VERSION}/vegeta_${VEGETA_VERSION}_linux_${TARGETARCH}.tar.gz -o vegeta.tar.gz && \
    tar xzf vegeta.tar.gz -C /usr/local/bin vegeta && \
    rm vegeta.tar.gz && \
    chmod +x /usr/local/bin/vegeta
WORKDIR /http-load
COPY run.sh run.sh
RUN chmod +x ./run.sh
LABEL krknctl.is_a_scenario="false"
LABEL krknctl.privileged="false"
LABEL krknctl.title="Krkn HTTP Load Workload"
LABEL krknctl.description="HTTP load generator workload used by Krkn scenarios."
ENTRYPOINT ["/bin/bash", "run.sh"]
