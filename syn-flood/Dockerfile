# Dockerfile for kraken

#FROM quay.io/krkn-chaos/krkn:latest
FROM quay.io/rh_ee_tsebasti/krkn:syn
ENV KUBECONFIG /home/krkn/.kube/config

# Copy configurations
COPY metrics_config.yaml.template /home/krkn/kraken/config/kube_burner.yaml.template
COPY config.yaml.template /home/krkn/kraken/config/config.yaml.template
COPY syn-flood/env.sh /home/krkn/env.sh
COPY syn-flood/build_config_file.py /home/krkn/build_config_file.py
COPY env.sh /home/krkn/main_env.sh
COPY syn-flood/run.sh /home/krkn/run.sh
COPY common_run.sh /home/krkn/common_run.sh

ENTRYPOINT /home/krkn/run.sh
