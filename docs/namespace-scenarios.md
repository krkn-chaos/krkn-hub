### Namespace Scenarios
This scenario deletes a namespace in your Kubernetes/OpenShift cluster. More information can be found [here](https://github.com/redhat-chaos/krkn/blob/master/docs/namespace_scenarios.md).

#### Run
If enabling [Cerberus](https://github.com/redhat-chaos/krkn#kraken-scenario-passfail-criteria-and-report) to monitor the cluster and pass/fail the scenario post chaos, refer [docs](https://github.com/redhat-chaos/krkn-hub/tree/main/docs/cerberus.md). Make sure to start it before injecting the chaos and set `CERBERUS_ENABLED` environment variable for the chaos injection container to autoconnect.

```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/redhat-chaos/krkn-hub:namespace-scenarios
# podman logs -f <container_name or container_id> # Streams Kraken logs
$ podman inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

```
$ docker run $(./get_docker_params.sh) --name=<container_name> --net=host -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/redhat-chaos/krkn-hub:namespace-scenarios
OR 
$ docker run -e <VARIABLE>=<value> --net=host -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/redhat-chaos/krkn-hub:namespace-scenarios

$ docker logs -f <container_name or container_id> # Streams Kraken logs
$ docker inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

#### Demo
See [here](https://asciinema.org/a/kKPSI0D7upV9HQWH5jnroTaKb) for a demo of this scenario

#### Supported parameters

The following environment variables can be set on the host running the container to tweak the scenario/faults being injected:

ex.) 
`export <parameter_name>=<value>`

See list of variables that apply to all scenarios [here](all_scenarios_env.md) that can be used/set in addition to these scenario specific variables

Parameter               | Description                                                           | Default
----------------------- | -----------------------------------------------------------------     | ------------------------------------ |
ACTION                  | Action to take on the namespace                                       | delete                                  |
LABEL_SELECTOR          | Label of the namespace to target. Set this parameter only if NAMESPACE is not set                                       |     ""                     |
NAMESPACE               | Name of the namespace you want to target. Set this parameter only if LABEL_SELECTOR is not set  | "openshift-etcd"                   |
SLEEP                   | Number of seconds to wait before polling to see if namespace exists again         | 15                                    |
DELETE_COUNT            | Number of namespaces to kill in each run, based on matching namespace and label specified | 1 |
RUNS                    | Number of runs to execute the action           | 1                                    |


**NOTE** In case of using custom metrics profile or alerts profile when `CAPTURE_METRICS` or `ENABLE_ALERTS` is enabled, mount the metrics profile from the host on which the container is run using podman/docker under `/root/kraken/config/metrics-aggregated.yaml` and `/root/kraken/config/alerts`. For example:
```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-custom-metrics-profile>:/root/kraken/config/metrics-aggregated.yaml -v <path-to-custom-alerts-profile>:/root/kraken/config/alerts -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/redhat-chaos/krkn-hub:container-scenarios
