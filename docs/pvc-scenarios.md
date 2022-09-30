### PVC Scenarios
This scenario fills up a given PersistenVolumeClaim by creating a temp file on the PVC from a pod associated with it. The purpose of this scenario is to fill up a volume to understand faults cause by the application using this volume. For more information refer the following [documentation](https://github.com/redhat-chaos/krkn/blob/master/docs/pvc_scenario.md).


#### Run

```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/chaos-kubox/krkn-hub:pvc-scenario
$ podman logs -f <container_name or container_id> # Streams Kraken logs
$ podman inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

```
$ docker run $(./get_docker_params.sh) --name=<container_name> --net=host -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/chaos-kubox/krkn-hub:pvc-scenario
OR 
$ docker run -e <VARIABLE>=<value> --name=<container_name> --net=host -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/chaos-kubox/krkn-hub:pvc-scenario

$ docker logs -f <container_name or container_id> # Streams Kraken logs
$ docker inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```
#### Supported parameters

The following environment variables can be set on the host running the container to tweak the scenario/faults being injected:

example: `export <parameter_name>=<value>`

If both `PVC_NAME` and `POD_NAME` are defined, `POD_NAME` value will be overridden from the `Mounted By:` value on PVC definition.

Parameter               | Description                                                                     | Default
----------------------- | -----------------------------------------------------------------               | ------------------------------------ |
PVC_NAME                | Targeted PersistentVolumeClaim in the cluster (if null, POD_NAME is required)   |                                      |
POD_NAME                | Targeted pod in the cluster (if null, PVC_NAME is required)                     |                                      |
NAMESPACE               | Targeted namespace in the cluster (required)                                    |                                      |
FILL_PERCENTAGE         | Targeted percentage to be filled up in the PVC                                  | 50                                   |
DURATION                | Duration in seconds with the PVC filled up                                      | 60                                   |
CERBERUS_ENABLED        | Set this to true if cerberus is running and monitoring the cluster              | False                                |
CERBERUS_URL            | URL to poll for the go/no-go signal                                             | http://0.0.0.0:8080                  |
WAIT_DURATION           | Duration in seconds to wait between each chaos scenario                         | 60                                   |
ITERATIONS              | Number of times to execute the scenarios                                        | 1                                    |
DAEMON_MODE             | Iterations are set to infinity which means that the kraken will cause chaos forever | False                            |
PUBLISH_KRAKEN_STATUS   | If you want                                                                     | True                                 |
PORT                    | Port to print kraken status to                                                  | 8081                                 |
LITMUS_VERSION          | Litmus version to install                                                       | v.1.13.8                             |
SIGNAL_STATE            | Waits for the RUN signal when set to PAUSE before running the scenarios, refer [docs](https://github.com/redhat-chaos/krkn/blob/master/docs/signal.md) for more details | RUN |
DEPLOY_DASHBOARDS | Deploys mutable grafana loaded with dashboards visualizing performance metrics pulled from in-cluster prometheus. The dashboard will be exposed as a route. | False |
CAPTURE_METRICS   | Captures metrics as specified in the profile from in-cluster prometheus. Default metrics captures are listed [here] (https://github.com/redhat-chaos/krkn/blob/master/config/metrics-aggregated.yaml) | False |
ENABLE_ALERTS     | Evaluates expressions from in-cluster prometheus and exits 0 or 1 based on the severity set. [Default profile](https://github.com/redhat-chaos/krkn/blob/master/config/alerts). More details can be found [here](https://github.com/redhat-chaos/krkn#alerts) | False |


**NOTE** Set NAMESPACE environment variable to `openshift-.*` to pick and disrupt pods randomly in openshift system namespaces, the DAEMON_MODE can also be enabled to disrupt the pods every x seconds in the background to check the reliability.
