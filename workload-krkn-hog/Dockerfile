FROM fedora@sha256:3c86d25fef9d2001712bc3d9b091fc40cf04be4767e48f1aa3b785bf58d300ed
RUN dnf update -y && dnf install --setopt=install_weak_deps=False -y stress-ng gettext-envsubst which && dnf clean all
WORKDIR /stress-ng
COPY . .
RUN chmod +x ./run.sh

LABEL krknctl.is_a_scenario="false"
LABEL krknctl.privileged="true"
LABEL krknctl.title="Krkn Hog Workload"
LABEL krknctl.description="Privileged CPU, memory, or I/O pressure workload used by Krkn scenarios."



ENTRYPOINT ["/bin/bash", "run.sh"]
