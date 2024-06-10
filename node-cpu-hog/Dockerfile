# Dockerfile for kraken

FROM quay.io/krkn-chaos/krkn:latest

ENV KUBECONFIG /home/krkn/.kube/config

# Copy configurations
COPY metrics_config.yaml.template /home/krkn/kraken/config/kube_burner.yaml.template
COPY config.yaml.template /home/krkn/kraken/config/config.yaml.template
COPY node-cpu-hog/env.sh /home/krkn/env.sh
COPY env.sh /home/krkn/main_env.sh
COPY node-cpu-hog/run.sh /home/krkn/run.sh
COPY node-cpu-hog/input.yaml.template /home/krkn/kraken/scenarios/arcaflow/cpu-hog/input.yaml.template
COPY common_run.sh /home/krkn/common_run.sh

ENTRYPOINT /home/krkn/run.sh
