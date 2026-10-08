FROM fedora@sha256:3c86d25fef9d2001712bc3d9b091fc40cf04be4767e48f1aa3b785bf58d300ed

env TARGET $TARGET
env DURATION $DURATION
env TARGET_PORT $TARGET_PORT
env PACKET_SIZE $PACKET_SIZE
env WINDOW_SIZE $WINDOW_SIZE
USER root
RUN dnf update -y && dnf install --setopt=install_weak_deps=False -y hping3 && dnf clean all
WORKDIR /syn-flood
COPY run.sh run.sh
RUN chmod +x ./run.sh
LABEL krknctl.is_a_scenario="false"
LABEL krknctl.privileged="true"
LABEL krknctl.title="Krkn SYN Flood Workload"
LABEL krknctl.description="Privileged SYN flood attacker workload used by Krkn scenarios."
#ENTRYPOINT ["/bin/bash", "run.sh", $TARGET, $DURATION, $TARGET_PORT, $PACKET_SIZE, $WINDOW_SIZE]
ENTRYPOINT ["/bin/bash", "run.sh"]
