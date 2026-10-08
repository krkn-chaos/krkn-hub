# syntax=docker/dockerfile:1

FROM registry.fedoraproject.org/fedora-minimal:45@sha256:42bf33f3a205e6a8f57adecba888369f17c051ddb37adc73c6aebebc578035b4

RUN dnf -y update && \
    dnf -y install --setopt=install_weak_deps=False \
        bash \
        coreutils \
        ethtool \
        findutils \
        gawk \
        grep \
        iproute \
        iproute-tc \
        iptables \
        iputils \
        kmod \
        nmap-ncat \
        procps-ng \
        psmisc \
        systemd \
        tcpdump \
        util-linux \
        which \
    && dnf clean all \
    && rm -rf /var/cache/dnf

LABEL krknctl.is_a_scenario="false"
LABEL krknctl.privileged="true"
LABEL krknctl.title="Krkn Network Tools Workload"
LABEL krknctl.description="Privileged helper image providing host network, storage, and time administration tools for Krkn scenarios."

CMD ["/usr/bin/bash"]
