### Node Memory hog scenario
This scenario hogs the memory on the specified node on a Kubernetes/OpenShift cluster for a specified duration. For more information refer the following [documentation](https://github.com/krkn-chaos/krkn/blob/main/docs/arcaflow_scenarios/memory_hog.md).

#### Run
If enabling [Cerberus](https://github.com/krkn-chaos/krkn#kraken-scenario-passfail-criteria-and-report) to monitor the cluster and pass/fail the scenario post chaos, refer [docs](https://github.com/redhat-chaos/krkn-hub/tree/main/docs/cerberus.md). Make sure to start it before injecting the chaos and set `CERBERUS_ENABLED` environment variable for the chaos injection container to autoconnect.

```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-kube-config>:/home/krkn/.kube/config:Z -d quay.io/krkn-chaos/krkn-hub:node-memory-hog
$ podman logs -f <container_name or container_id> # Streams Kraken logs
$ podman inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

```
$ docker run $(./get_docker_params.sh) --name=<container_name> --net=host -v <path-to-kube-config>:/home/krkn/.kube/config:Z -d quay.io/krkn-chaos/krkn-hub:node-memory-hog
OR 
$ docker run -e <VARIABLE>=<value> --net=host -v <path-to-kube-config>:/home/krkn/.kube/config:Z -d quay.io/krkn-chaos/krkn-hub:node-memory-hog

$ docker logs -f <container_name or container_id> # Streams Kraken logs
$ docker inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```
**TIP**: Because the container runs with a non-root user, ensure the kube config is globally readable before mounting it in the container. You can achieve this with the following commands:
```kubectl config view --flatten > ~/kubeconfig && chmod 444 ~/kubeconfig && docker run $(./get_docker_params.sh) --name=<container_name> --net=host -v ~kubeconfig:/home/krkn/.kube/config:Z -d quay.io/krkn-chaos/krkn-hub:<scenario>```
#### Supported parameters

The following environment variables can be set on the host running the container to tweak the scenario/faults being injected:

ex.) 
`export <parameter_name>=<value>`


See list of variables that apply to all scenarios [here](all_scenarios_env.md) that can be used/set in addition to these scenario specific variables

|  Parameter                    | Description                                                           | Default
|-------------------------------| -----------------------------------------------------------------     | ------------------------------------ |
| TOTAL_CHAOS_DURATION          | Set chaos duration (in sec) as desired                                | 60                                  |
| MEMORY_CONSUMPTION_PERCENTAGE | percentage  (expressed with the suffix %) or amount (expressed with the suffix b, k, m or g) of memory to be consumed by the scenario | 90% |
| NUMBER_OF_WORKERS             | Total number of workers (stress-ng threads)   | 1    |
| NAMESPACE                     | Namespace where the scenario container will be deployed | default |
| NODE_SELECTOR                 | defines the node selector for choosing target nodes. If not specified, one schedulable node in the cluster will be chosen at random. If multiple nodes match the selector, all of them will be subjected to stress. If number-of-nodes is specified, that many nodes will be randomly selected from those identified by the selector.                                     | "" |                             |
| NODE_NAME                     | Target specific node(s) by name. Supports single node, comma-separated list, or YAML list format. Takes precedence over NODE_SELECTOR when specified.                                     | "" |                             |
| NUMBER_OF_NODES               | restricts the number of selected nodes by the selector                                     | "" |                             |
| IMAGE                         | the container image of the stress workload|quay.io/krkn-chaos/krkn-hog||                          


**NOTE** In case of using custom metrics profile or alerts profile when `CAPTURE_METRICS` or `ENABLE_ALERTS` is enabled, mount the metrics profile from the host on which the container is run using podman/docker under `/home/krkn/kraken/config/metrics-aggregated.yaml` and `/home/krkn/kraken/config/alerts`. For example:
```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-custom-metrics-profile>:/home/krkn/kraken/config/metrics-aggregated.yaml -v <path-to-custom-alerts-profile>:/home/krkn/kraken/config/alerts -v <path-to-kube-config>:/home/krkn/.kube/config:Z -d quay.io/krkn-chaos/krkn-hub:node-memory-hog
```

#### Demo
You can find a link to a demo of the scenario [here](https://asciinema.org/a/452742?speed=3&theme=solarized-dark)
