# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /root/.kube/config

# Install dependencies
RUN yum install -y which

# Copy configurations
COPY config.yaml.template /root/kraken/config/config.yaml.template
COPY metrics_config.yaml.template /root/kraken/config/kube_burner.yaml.template
COPY node-scenarios/env.sh /root/env.sh
COPY env.sh /root/main_env.sh
COPY node-scenarios/run.sh /root/run.sh
COPY common_run.sh /root/common_run.sh
COPY node-scenarios/node_scenario.yaml.template /root/kraken/scenarios/node_scenario.yaml.template
COPY node-scenarios/plugin_node_scenario.yaml.template /root/kraken/scenarios/plugin_node_scenario.yaml.template
ENTRYPOINT /root/run.sh
