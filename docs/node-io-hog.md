### Node IO hog scenario
This scenario hogs the IO on the specified node on a Kubernetes/OpenShift cluster for a specified duration. For more information refer the following [documentation](https://github.com/cloud-bulldozer/kraken/blob/master/docs/litmus_scenarios.md).

#### Run
If enabling [Cerberus](https://github.com/cloud-bulldozer/kraken#kraken-scenario-passfail-criteria-and-report) to monitor the cluster and pass/fail the scenario post chaos, refer [docs](https://github.com/cloud-bulldozer/kraken-hub/tree/main/docs/cerberus.md). Make sure to start it before injecting the chaos and set `CERBERUS_ENABLED` environment variable for the chaos injection container to autoconnect.

```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/openshift-scale/kraken:node-io-hog
$ podman logs -f <container_name or container_id> # Streams Kraken logs
$ podman inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

```
$ docker run $(./get_docker_params.sh) --name=<container_name> --net=host -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/openshift-scale/kraken:node-io-hog
OR 
$ docker run -e <VARIABLE>=<value> --net=host -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/openshift-scale/kraken:node-io-hog

$ docker logs -f <container_name or container_id> # Streams Kraken logs
$ docker inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

#### Supported parameters

The following environment variables can be set on the host running the container to tweak the scenario/faults being injected:

ex.) 
`export <parameter_name>=<value>`

Parameter               | Description                                                           | Default
----------------------- | -----------------------------------------------------------------     | ------------------------------------ |
JOB_CLEANUP_POLICY      | It can be delete/retain                                               | delete                               |
TOTAL_CHAOS_DURATION    | Set chaos duration (in sec) as desired                                | 300                                  |
FILESYSTEM_UTILIZATION_PERCENTAGE | Specify the size as percentage of free space on the file system | 90                               |
NUMBER_OF_WORKERS       | Total number of workers ( only set if not targeting specific nodes    | ""                                    |
CPU                     | Number of core of CPU                                                 | 2                                    |
TARGET_NODES            | Enter the comma separated targeted node names ( Required ) or set the `NUMBER_OF_WORKERS` parameter            | ""                                   |
CERBERUS_ENABLED        | Set this to true if cerberus is running and monitoring the cluster    | False                                |
CERBERUS_URL            | URL to poll for the go/no-go signal                                   | http://0.0.0.0:8080                  |
WAIT_DURATION           | Duration in seconds to wait between each chaos scenario               | 60                                   |
ITERATIONS              | Number of times to execute the scenarios                              | 1                                    |
DAEMON_MODE             | Iterations are set to infinity which means that the kraken will cause chaos forever | False                  |
PUBLISH_KRAKEN_STATUS              | If you want                         | True                                    |
PORT              | Port to print kraken status to                             | 8081                                    |
LITMUS_VERSION             | Litmus version to install | v.1.13.8                 |
SIGNAL_STATE      | Waits for the RUN signal when set to PAUSE before running the scenarios, refer [docs](https://github.com/cloud-bulldozer/kraken/blob/master/docs/signal.md) for more details | RUN |
DEPLOY_DASHBOARDS | Deploys mutable grafana loaded with dashboards visualizing performance metrics pulled from in-cluster prometheus. The dashboard will be exposed as a route. | False |
