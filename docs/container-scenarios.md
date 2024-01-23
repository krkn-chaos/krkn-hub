### Container Scenarios
This scenario disrupts the containers matching the label in the specified namespace on a Kubernetes/OpenShift cluster.

#### Run
If enabling [Cerberus](https://github.com/redhat-chaos/krkn#kraken-scenario-passfail-criteria-and-report) to monitor the cluster and pass/fail the scenario post chaos, refer [docs](https://github.com/redhat-chaos/krkn-hub/tree/main/docs/cerberus.md). Make sure to start it before injecting the chaos and set `CERBERUS_ENABLED` environment variable for the chaos injection container to autoconnect.

```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/redhat-chaos/krkn-hub:container-scenarios
$ podman logs -f <container_name or container_id> # Streams Kraken logs
$ podman inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

```
$ docker run $(./get_docker_params.sh) --name=<container_name> --net=host -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/redhat-chaos/krkn-hub:container-scenarios
OR 
$ docker run -e <VARIABLE>=<value> --net=host -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/redhat-chaos/krkn-hub:container-scenarios

$ docker logs -f <container_name or container_id> # Streams Kraken logs
$ docker inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

#### Supported parameters

The following environment variables can be set on the host running the container to tweak the scenario/faults being injected:

See list of variables that apply to all scenarios [here](all_scenarios_env.md) that can be used/set in addition to these scenario specific variables

ex.) 
`export <parameter_name>=<value>`

Parameter               | Description                                                           | Default
----------------------- | -----------------------------------------------------------------     | ------------------------------------ |
NAMESPACE               | Targeted namespace in the cluster                                     | openshift-etcd                       |
LABEL_SELECTOR          | Label of the container(s) to target                                   | k8s-app=etcd                         | 
DISRUPTION_COUNT        | Number of container to disrupt                                        | 1                                    |
CONTAINER_NAME          | Name of the container to disrupt                                      | etcd                                 |
ACTION                  | kill signal to run. For example 1 ( hang up ) or 9                    | 1                                    |
EXPECTED_RECOVERY_TIME  | Time to wait before checking if all containers that were affected recover properly | 60                      |

**NOTE** In case of using custom metrics profile or alerts profile when `CAPTURE_METRICS` or `ENABLE_ALERTS` is enabled, mount the metrics profile from the host on which the container is run using podman/docker under `/root/kraken/config/metrics-aggregated.yaml` and `/root/kraken/config/alerts`. For example:
```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-custom-metrics-profile>:/root/kraken/config/metrics-aggregated.yaml -v <path-to-custom-alerts-profile>:/root/kraken/config/alerts -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/redhat-chaos/krkn-hub:container-scenarios
```


#### Demo
You can find a link to a demo of the scenario [here](https://asciinema.org/a/BXqs9JSGDSEKcydTIJ5LpPZBM?speed=3&theme=solarized-dark)
