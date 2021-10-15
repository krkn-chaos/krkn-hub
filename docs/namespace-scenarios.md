### Namespace Scenarios
This scenario deletes a namespace in your Kubernetes/OpenShift cluster. More information can be found [here](https://github.com/cloud-bulldozer/kraken/blob/master/docs/namespace_scenarios.md).

#### Run
If enabling [Cerberus](https://github.com/cloud-bulldozer/kraken#kraken-scenario-passfail-criteria-and-report) to monitor the cluster and pass/fail the scenario post chaos, refer [docs](https://github.com/cloud-bulldozer/kraken-hub/tree/main/docs/cerberus.md). Make sure to start it before injecting the chaos and set `CERBERUS_ENABLED` environment variable for the chaos injection container to autoconnect.

```
$ podman run --name=<container_name> --net=host --env-host=true -v $KUBECONFIG:/root/.kube/config:Z -d quay.io/openshift-scale/kraken:namespace-scenarios
# podman logs -f <container_name or container_id> # Streams Kraken logs
$ podman inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```


#### Supported parameters

The following environment variables can be set on the host running the container to tweak the scenario/faults being injected:

ex.) 
`export <parameter_name>=<value>`

Parameter               | Description                                                           | Default
----------------------- | -----------------------------------------------------------------     | ------------------------------------ |
KUBECONFIG              | Path to the kubeconfig to access the cluster API                      | /root/.kube/config                   |
ACTION                  | Action to take on the namespace                                       | delete                                  |
LABEL_SELECTOR          | Label of the namspace to target                                       |                          |
OBJECT_NAME             | List of the names of pods or nodes you want to skew ( optional parameter )                   | []                                   |
NAMESPACE               | Namespace of the pods you want to skew, need to be set only if setting a specific pod name | ""                   |
CERBERUS_ENABLED        | Set this to true if cerberus is running and monitoring the cluster    | False                                |
CERBERUS_URL            | URL to poll for the go/no-go signal                                   | http://0.0.0.0:8080                  |
SLEEP                   | Duration in seconds to wait between each chaos scenario               | 60                                   |
RUNS                    | Number of namespaces to take the action on in each scenario           | 1                                    |
ITERATIONS              | Number of times to execute the scenarios                              | 1                                    |
DAEMON_MODE             | Iterations are set to infinity which means that the kraken will cause chaos forever | False                  |
