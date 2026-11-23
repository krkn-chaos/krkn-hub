# Copyright 2026 The Krkn Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ARG KRKN_IMAGE=quay.io/krkn-chaos/krkn:latest
FROM ${KRKN_IMAGE} AS krkn
FROM scratch AS gpu_runtime
COPY --from=krkn /home/krkn/kraken/krkn/scenario_plugins/gpu/runtime/ /

FROM python:3.11-slim

# NVIDIA runtime supplies driver libraries, or GPU_DRIVER_ROOT is mounted at
# /host-driver; keep its library paths alongside NVIDIA Container Toolkit paths.
ENV NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility \
    LD_LIBRARY_PATH=/host-driver/usr/lib64:/host-driver/usr/lib/x86_64-linux-gnu:/host-driver/usr/lib/aarch64-linux-gnu:/host-driver/lib64:/host-driver/lib/x86_64-linux-gnu:/host-driver/lib/aarch64-linux-gnu:/usr/local/nvidia/lib:/usr/local/nvidia/lib64 \
    PYTHONPATH=/opt/krkn_gpu:/opt

WORKDIR /opt
RUN python3 -m venv /opt/venv && /opt/venv/bin/python -m pip install --no-cache-dir grpcio==1.76.0 grpcio-tools==1.76.0 protobuf==6.33.5 && mkdir -p /opt/krkn_gpu
COPY --from=gpu_runtime /*.py /opt/krkn_gpu/
COPY --from=gpu_runtime /podresources.proto /opt/krkn_gpu/podresources.proto
RUN cd /opt/krkn_gpu && /opt/venv/bin/python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. podresources.proto

LABEL krknctl.is_a_scenario="false"
LABEL krknctl.privileged="true"
LABEL krknctl.title="Krkn GPU Workload"
LABEL krknctl.description="Privileged VRAM pressure workload used by Krkn GPU scenarios."

ENTRYPOINT ["/opt/venv/bin/python", "-u", "-m", "krkn_gpu.worker"]
