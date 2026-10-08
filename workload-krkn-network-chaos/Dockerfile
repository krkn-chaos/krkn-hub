FROM fedora@sha256:43b29f65a41eb9c35e1cd5323e3bdf3b655c2357a9f4f1ff2f9c2798e5045d80
RUN dnf update -y && dnf install --setopt=install_weak_deps=False -y iproute-tc iproute iptables && dnf clean all

LABEL krknctl.is_a_scenario="false"
LABEL krknctl.privileged="true"
LABEL krknctl.title="Krkn Network Chaos Workload"
LABEL krknctl.description="Privileged network fault-injection workload used by Krkn scenarios."



ENTRYPOINT ["/usr/bin/sleep" , "infinity"]
