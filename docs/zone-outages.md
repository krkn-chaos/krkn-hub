### Zone Outage Scenarios
This scenario disrupts a targeted zone in the public cloud by blocking egress and ingress traffic to understand the impact on both Kubernetes/OpenShift platforms control plane as well as applications running on the worker nodes in that zone. More information is documented [here](https://github.com/cloud-bulldozer/kraken/blob/master/docs/zone_outage.md)

#### Run

If enabling [Cerberus](https://github.com/cloud-bulldozer/kraken#kraken-scenario-passfail-criteria-and-report) to monitor the cluster and pass/fail the scenario post chaos, refer [docs](https://github.com/cloud-bulldozer/kraken-hub/tree/main/docs/cerberus.md). Make sure to start it before injecting the chaos and set `CERBERUS_ENABLED` environment variable for the chaos injection container to autoconnect.
 
```
$ podman run --name=<container_name> --net=host --env-host=true -v $KUBECONFIG:/root/.kube/config:Z -d quay.io/openshift-scale/kraken:zone-outages
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
CLOUD_TYPE              | Cloud platform on top of which cluster is running, [supported cloud platforms](https://github.com/cloud-bulldozer/kraken/blob/master/docs/node_scenarios.md)                     | aws |
DURATION                | Duration in seconds after which the zone will be back online          | 600                                  |
VPC_ID                  | cluster virtual private network to target ( REQUIRED )                             | ""                                   |
SUBNET_ID               | subnet-id to deny both ingress and egress traffic ( REQUIRED ). Format: [subenet1, subnet2]                    | ""                                   |
CERBERUS_ENABLED        | Set this to true if cerberus is running and monitoring the cluster    | False                                |
CERBERUS_URL            | URL to poll for the go/no-go signal                                   | http://0.0.0.0:8080                  |
WAIT_DURATION           | Duration in seconds to wait between each chaos scenario               | 60                                   |
ITERATIONS              | Number of times to execute the scenarios                              | 1                                    |
DAEMON_MODE             | Iterations are set to infinity which means that the kraken will cause chaos forever | False                  |

The following environment variables need to be set for the scenarios that requires intereacting with the cloud platform API to perform the actions:

Amazon Web Services
```
$ export AWS_ACCESS_KEY_ID=<>
$ export AWS_SECRET_ACCESS_KEY=<>
$ export AWS_DEFAULT_REGION=<>
```

Google Cloud Platform
```
TBD
```

Azure
```
TBD
```

OpenStack

```
TBD
```

Baremetal
```
TBD
```
