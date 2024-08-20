# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /home/krkn/.kube/config

USER root
RUN yum install -y OpenIPMI ipmitool
USER krkn

# Copy configurations
COPY config.yaml.template /home/krkn/kraken/config/config.yaml.template
COPY metrics_config.yaml.template /home/krkn/kraken/config/kube_burner.yaml.template
COPY node-scenarios/env.sh /home/krkn/env.sh
COPY env.sh /home/krkn/main_env.sh
COPY node-scenarios/run.sh /home/krkn/run.sh
COPY common_run.sh /home/krkn/common_run.sh
COPY node-scenarios/node_scenario.yaml.template /home/krkn/kraken/scenarios/node_scenario.yaml.template
COPY node-scenarios/plugin_node_scenario.yaml.template /home/krkn/kraken/scenarios/plugin_node_scenario.yaml.template
COPY node-scenarios/baremetal_node_scenario.yaml.template /home/krkn/kraken/scenarios/baremetal_node_scenario.yaml.template
ENTRYPOINT /home/krkn/run.sh
