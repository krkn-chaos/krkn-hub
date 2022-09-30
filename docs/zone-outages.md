### Zone Outage Scenarios
This scenario disrupts a targeted zone in the public cloud by blocking egress and ingress traffic to understand the impact on both Kubernetes/OpenShift platforms control plane as well as applications running on the worker nodes in that zone. More information is documented [here](https://github.com/redhat-chaos/krkn/blob/master/docs/zone_outage.md)

#### Run

If enabling [Cerberus](https://github.com/redhat-chaos/krkn#kraken-scenario-passfail-criteria-and-report) to monitor the cluster and pass/fail the scenario post chaos, refer [docs](https://github.com/redhat-chaos/krkn-hub/tree/main/docs/cerberus.md). Make sure to start it before injecting the chaos and set `CERBERUS_ENABLED` environment variable for the chaos injection container to autoconnect.
 
```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/chaos-kubox/krkn-hub:zone-outages
$ podman logs -f <container_name or container_id> # Streams Kraken logs
$ podman inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

```
$ docker run $(./get_docker_params.sh) --name=<container_name> --net=host -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/chaos-kubox/krkn-hub:zone-outages
OR 
$ docker run -e <VARIABLE>=<value> --name=<container_name> --net=host -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/chaos-kubox/krkn-hub:zone-outages

$ docker logs -f <container_name or container_id> # Streams Kraken logs
$ docker inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

#### Supported parameters

The following environment variables can be set on the host running the container to tweak the scenario/faults being injected:

ex.) 
`export <parameter_name>=<value>`

Parameter               | Description                                                           | Default
----------------------- | -----------------------------------------------------------------     | ------------------------------------ |
CLOUD_TYPE              | Cloud platform on top of which cluster is running, [supported cloud platforms](https://github.com/redhat-chaos/krkn/blob/master/docs/node_scenarios.md)                     | aws |
DURATION                | Duration in seconds after which the zone will be back online          | 600                                  |
VPC_ID                  | cluster virtual private network to target ( REQUIRED )                             | ""                                   |
SUBNET_ID               | subnet-id to deny both ingress and egress traffic ( REQUIRED ). Format: [subenet1, subnet2]                    | ""                                   |
CERBERUS_ENABLED        | Set this to true if cerberus is running and monitoring the cluster    | False                                |
CERBERUS_URL            | URL to poll for the go/no-go signal                                   | http://0.0.0.0:8080                  |
WAIT_DURATION           | Duration in seconds to wait between each chaos scenario               | 60                                   |
ITERATIONS              | Number of times to execute the scenarios                              | 1                                    |
DAEMON_MODE             | Iterations are set to infinity which means that the kraken will cause chaos forever | False                  |
PUBLISH_KRAKEN_STATUS              | If you want                         | True                                    |
PORT              | Port to print kraken status to                             | 8081                                    |
LITMUS_VERSION             | Litmus version to install | v.1.13.8                 |
SIGNAL_STATE      | Waits for the RUN signal when set to PAUSE before running the scenarios, refer [docs](https://github.com/redhat-chaos/krkn/blob/master/docs/signal.md) for more details | RUN |
DEPLOY_DASHBOARDS | Deploys mutable grafana loaded with dashboards visualizing performance metrics pulled from in-cluster prometheus. The dashboard will be exposed as a route. | False |
CAPTURE_METRICS   | Captures metrics as specified in the profile from in-cluster prometheus. Default metrics captures are listed [here] (https://github.com/redhat-chaos/krkn/blob/master/config/metrics-aggregated.yaml) | False |
ENABLE_ALERTS     | Evaluates expressions from in-cluster prometheus and exits 0 or 1 based on the severity set. [Default profile](https://github.com/redhat-chaos/krkn/blob/master/config/alerts). More details can be found [here](https://github.com/redhat-chaos/krkn#alerts) | False |


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

**NOTE** In case of using custom metrics profile or alerts profile when `CAPTURE_METRICS` or `ENABLE_ALERTS` is enabled, mount the metrics profile from the host on which the container is run using podman/docker under `/root/kraken/config/metrics-aggregated.yaml` and `/root/kraken/config/alerts`. For example:
```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-custom-metrics-profile>:/root/kraken/config/metrics-aggregated.yaml -v <path-to-custom-alerts-profile>:/root/kraken/config/alerts -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/chaos-kubox/krkn-hub:container-scenarios
```

#### Demo
You can find a link to a demo of the scenario [here](https://asciinema.org/a/452672?speed=3&theme=solarized-dark)
