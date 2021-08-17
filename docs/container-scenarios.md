### Pod Scenarios
This scenario disrupts the containers matching the label in the specified namespace on a Kubernetes/OpenShift cluster.

#### Run

```
$ podman run --name=<container_name> --net=host --env-host=true -v <kube_config_path>:/root/.kube/confi:Z -d quay.io/openshift-scale/kraken:container-scenarios
# podman logs -f <container_name or container_id> # Streams Kraken logs
$ podman inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

#### Supported parameters

The following environment variables can be set on the host running the container to tweak the scenario/faults being injected:

Parameter               | Description                                                           | Default
----------------------- | -----------------------------------------------------------------     | ------------------------------------ |
KUBECONFIG              | Path to the kubeconfig to access the cluster API                      | /root/.kube/config                   |
NAMESPACE               | Targeted namespace in the cluster                                     | openshift-etcd                       |
LABEL_SELECTOR          | Label of the container(s) to target                                   | k8s-app=etcd                         | 
DISRUPTION_COUNT        | Number of container to disrupt                                        | 1                                    |
CONTAINER_NAME          | Name of the container to disrupt                                      | etcd                                 |
ACTION                  | Action to run. For example kill 1 ( hang up ) or kill 9               | kill 1                               |
CERBERUS_ENABLED        | Set this to true if cerberus is running and monitoring the cluster    | False                                |
CERBERUS_URL            | URL to poll for the go/no-go signal                                   | http://0.0.0.0:8080                  |
