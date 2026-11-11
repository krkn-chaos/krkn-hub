# Krkn-hub aka kraken-hub

Hosts container images and wrapper for running scenarios supported by [Krkn](https://krkn-chaos.dev/docs/), a chaos testing tool for Kubernetes clusters to ensure it is resilient to failures. All we need to do is run the containers with the respective environment variables defined as supported by the scenarios without having to maintain and tweak files!

### Documentation 
[Krkn-Hub Documentation](https://krkn-chaos.dev/docs/krkn-hub/) is your go-to resource for all things Krkn-Hub.  
The documentation provides detailed information about the supported scenarios, how to configure and run them using Krkn-Hub, and insights into leveraging the tool for chaos testing. It also includes setup instructions, usage examples, and best practices for integrating Krkn-Hub into your Kubernetes workflows.  

## Reusable scenario runner conventions

Scenario `env.sh` files define the scenario output path and input template so
the same `run.sh` can be reused with caller-provided environment variables.
Keep the defaults overridable:

```bash
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/app_outage.yaml}
export SCENARIO_TEMPLATE_FILE=${SCENARIO_TEMPLATE_FILE:=app_outage.yaml.template}
```

`SCENARIO_FILE` names the rendered scenario. Relative paths are resolved under
`KRAKEN_FOLDER`; absolute paths are preserved. `SCENARIO_TEMPLATE_FILE` is
relative to `$KRAKEN_FOLDER/scenarios/`. Include a subdirectory when the
template is nested, such as `kube/io-hog.yml.template`.

Source `common_run.sh` before calling `resolve_scenario_path`, then use the
resolved path for rendering and all later reads or modifications:

```bash
source "$ROOT_FOLDER/env.sh"
source "$ROOT_FOLDER/common_run.sh"
SCENARIO_PATH="$(resolve_scenario_path "$SCENARIO_FILE" "$KRAKEN_FOLDER")"

envsubst < "$KRAKEN_FOLDER/scenarios/$SCENARIO_TEMPLATE_FILE" > "$SCENARIO_PATH"
```

If a scenario uses different templates based on another variable, select the
default in `env.sh` while preserving an explicit `SCENARIO_TEMPLATE_FILE`
override:

```bash
if [[ "$CLOUD_TYPE" == "gcp" ]]; then
  export SCENARIO_TEMPLATE_FILE=${SCENARIO_TEMPLATE_FILE:=zone_outage_scenario_gcp.yaml.template}
else
  export SCENARIO_TEMPLATE_FILE=${SCENARIO_TEMPLATE_FILE:=zone_outage_scenario.yaml.template}
fi
```

Keep configuration template/output paths specific to the scenario, and quote
`ROOT_FOLDER` and `KRAKEN_FOLDER` whenever they are used as paths.

<!-- ### Supported chaos scenarios

Scenario   | Description                                                      | Working
------------------------------------------- |------------------------------------------------------------------| -------------------- |  
[Pod failures](docs/pod-scenarios.md) | Injects pod failures                                             | :heavy_check_mark: |
[Container failures](docs/container-scenarios.md) | Injects container failures based on the provided kill signal     | :heavy_check_mark: | 
[Node failures](docs/node-scenarios.md) | Injects node failure through OpenShift/Kubernetes, cloud API's   | :heavy_check_mark: |
[zone outages](docs/zone-outages.md) | Creates zone outage to observe the impact on the cluster, applications | :heavy_check_mark: |
[time skew](docs/time-scenarios.md) | Skews the time and date                                          | :heavy_check_mark: |
[Node cpu hog](docs/node-cpu-hog.md) | Hogs CPU on the targeted nodes                                   | :heavy_check_mark: |
[Node memory hog](docs/node-memory-hog.md) | Hogs memory on the targeted nodes                                | :heavy_check_mark:  |
[Node IO hog](docs/node-io-hog.md) | Hogs io on the targeted nodes                                    | :heavy_check_mark: |
[Service Disruption](docs/service-disruption-scenarios.md) | Deleting all objects within a namespace                          | :heavy_check_mark: | 
[Application outages](docs/application-outages.md) | Isolates application Ingress/Egress traffic to observe the impact on dependent applications and recovery/initialization timing | :heavy_check_mark: |
[Power Outages](docs/power-outages.md) | Shuts down the cluster for the specified duration and turns it back on to check the cluster health | :heavy_check_mark: |
[PVC disk fill](docs/pvc-scenarios.md) | Fills up a given PersistenVolumeClaim by creating a temp file on the PVC from a pod associated with it | :heavy_check_mark: |
[Network Chaos](docs/network-chaos.md) | Introduces network latency, packet loss, bandwidth restriction in the egress traffic of a Node's interface using tc and Netem | :heavy_check_mark: | 
[Pod Network Chaos](docs/pod-network-chaos.md) | Introduces network chaos at pod level                            | :heavy_check_mark: |
[Service Hijacking](docs/service-hijacking.md) | Hijacks a service http traffic to simulate custom HTTP responses | :heavy_check_mark: |
[SYN Flood](docs/syn-flood.md) | Simulates a user-defined surge of TCP SYN requests directed at one or more services | :heavy_check_mark: | -->

<!-- ### Utilities

Utility | Description | Working|
--------|-------------|--------|
[Chaos Recommender](docs/chaos-recommender.md) | Runs the chaos recommender | :heavy_check_mark: |


### Set Up 
You can use docker or podman to run kraken-hub

Install Podman your certain operating system based on these [instructions](https://podman.io/getting-started/installation) 

or 

Install [Docker](https://docs.docker.com/engine/install/)

Docker is also supported but all variables you want to set (separate from the defaults) need to be set at the command line
In the form `-e <VARIABLE>=<value>`

You can take advantage of the [get_docker_params.sh](get_docker_params.sh) script to create your parameters string
This will take all environment variables and put them in the form "-e <var>=<value>" to make a long string that can get passed to the command

For example: 
`docker run $(./get_docker_params.sh) --net=host -v <path-to-kube-config>:/home/krkn/.kube/config:Z -d quay.io/krkn-chaos/krkn-hub-multiarch:power-outages`

**TIP**: Because the container runs with a non-root user, ensure the kube config is globally readable before mounting it in the container. You can achieve this with the following commands:
```kubectl config view --flatten > ~/kubeconfig && chmod 444 ~/kubeconfig && docker run $(./get_docker_params.sh) --name=<container_name> --net=host -v ~/kubeconfig:/home/krkn/.kube/config:Z -d quay.io/krkn-chaos/krkn-hub-multiarch:<scenario>```

### Adding New Scenarios/Testing Changes

Refer to the 2 docs below to be able to test your own images with any changes and be able to contribute them to the repository

- [Testing Your Changes](docs/test_your_changes.md)
- [Contribute](docs/contribute.md) -->
