### Time Skew Scenarios
This scenario skews the date and time of the nodes and pods matching the label on a Kubernetes/OpenShift cluster. More information can be found [here](https://github.com/redhat-chaos/krkn/blob/master/docs/time_scenarios.md).

#### Run
If enabling [Cerberus](https://github.com/redhat-chaos/krkn#kraken-scenario-passfail-criteria-and-report) to monitor the cluster and pass/fail the scenario post chaos, refer [docs](https://github.com/redhat-chaos/krkn-hub/tree/main/docs/cerberus.md). Make sure to start it before injecting the chaos and set `CERBERUS_ENABLED` environment variable for the chaos injection container to autoconnect.

```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/chaos-kubox/krkn-hub:time-scenarios
$ podman logs -f <container_name or container_id> # Streams Kraken logs
$ podman inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

```
$ docker run $(./get_docker_params.sh) --name=<container_name> --net=host -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/chaos-kubox/krkn-hub:time-scenarios
OR 
$ docker run -e <VARIABLE>=<value> --name=<container_name> --net=host -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/chaos-kubox/krkn-hub:time-scenarios

$ docker logs -f <container_name or container_id> # Streams Kraken logs
$ docker inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

#### Demo
[Here](https://asciinema.org/a/zMBAdzHE40oPXkFVIz0exEoOX) is a demo of kraken-hub in action

#### Supported parameters

The following environment variables can be set on the host running the container to tweak the scenario/faults being injected:

ex.) 
`export <parameter_name>=<value>`

See list of variables that apply to all scenarios [here](all_scenarios_env.md) that can be used/set in addition to these scenario specific variables

Parameter               | Description                                                           | Default
----------------------- | -----------------------------------------------------------------     | ------------------------------------ |
OBJECT_TYPE             | Object to target. Supported options: pod, node                        | pod                                  |
LABEL_SELECTOR          | Label of the container(s) or nodes to target                          | k8s-app=etcd                         |
ACTION                  | Action to run. Supported actions: skew_time, skew_date                | skew_date                            |
OBJECT_NAME             | List of the names of pods or nodes you want to skew ( optional parameter )                   | []                                   |
CONTAINER_NAME          | Container in the specified pod to target in case the pod has multiple containers running. Random container is picked if empty   | ""                                   |
NAMESPACE               | Namespace of the pods you want to skew, need to be set only if setting a specific pod name | ""                   |


**NOTE** In case of using custom metrics profile or alerts profile when `CAPTURE_METRICS` or `ENABLE_ALERTS` is enabled, mount the metrics profile from the host on which the container is run using podman/docker under `/root/kraken/config/metrics-aggregated.yaml` and `/root/kraken/config/alerts`. For example:
```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-custom-metrics-profile>:/root/kraken/config/metrics-aggregated.yaml -v <path-to-custom-alerts-profile>:/root/kraken/config/alerts -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/chaos-kubox/krkn-hub:container-scenarios
