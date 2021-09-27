### Node IO hog scenario
This scenario hogs the IO on the specified node on a Kubernetes/OpenShift cluster for a specified duration. For more information refer the following [documentation](https://github.com/cloud-bulldozer/kraken/blob/master/docs/litmus_scenarios.md).

#### Run
If enabling [Cerberus](https://github.com/cloud-bulldozer/kraken#kraken-scenario-passfail-criteria-and-report) to monitor the cluster and pass/fail the scenario post chaos, refer [docs](https://github.com/cloud-bulldozer/kraken-hub/tree/main/docs/cerberus.md). Make sure to start it before injecting the chaos and set `CERBERUS_ENABLED` environment variable for the chaos injection container to autoconnect.

```
$ podman run --name=<container_name> --net=host --env-host=true -v $KUBECONFIG:/root/.kube/config:Z -d quay.io/openshift-scale/kraken:node-io-hog
# podman logs -f <container_name or container_id> # Streams Kraken logs
$ podman inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

```
$ docker run --name=<container_name> --net=host -v $KUBECONFIG:/root/.kube/config:Z -d quay.io/openshift-scale/kraken:node-io-hog
# docker logs -f <container_name or container_id> # Streams Kraken logs
$ docker inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

#### Supported parameters

The following environment variables can be set on the host running the container to tweak the scenario/faults being injected:

ex.) 
`export <parameter_name>=<value>`

Parameter               | Description                                                           | Default
----------------------- | -----------------------------------------------------------------     | ------------------------------------ |
KUBECONFIG              | Path to the kubeconfig to access the cluster API                      | /root/.kube/config                   |
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
