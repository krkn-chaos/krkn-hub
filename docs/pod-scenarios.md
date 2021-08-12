### Pod Scenarios
This scenario disrupts the pods matching the label in the specified namespace on a Kubernetes/OpenShift cluster.

#### Run

```
$ podman run --name=<container_name> --net=host -v <kube_config_path>:/root/.kube/confi:Z -d quay.io/openshift-scale/kraken:pod-scenarios
# podman logs -f <container_name or container_id> # Streams Kraken logs
$ podman inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

#### Supported parameters

The following environment variables can be set on the host running the container to tweak the scenario/faults being injected:

Parameter               | Description                                                           | Default
----------------------- | -----------------------------------------------------------------     | ------------------------------------ |
KUBECONFIG              | Path to the kubeconfig to access the cluster API                      | /root/.kube/config                   |
RUNS                    | Number of iterations to run the scenario                              | 1                                    |
SECONDS_BETWEEN_RUNS    | Time in seconds to wait before each of the iteration                  | 30                                   |
NAMESPACE               | Targeted namespace in the cluster                                     | openshift-etcd                       |
POD_LABEL               | Label of the pod(s) to target                                         | app=etcd                             | 
DISRUPTION_COUNT        | Number of pods to disrupt                                             | 1                                    |
EXPECTED_POD_COUNT      | Total pod count matching the label to verify post disruption          | 3                                    |
TIMEOUT                 | Time in seconds to wait for the target pods to match EXPECTED_POD_COUNT | 180                                |
