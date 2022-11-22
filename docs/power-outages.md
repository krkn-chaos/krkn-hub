### Power Outages
This scenario shuts down Kubernetes/OpenShift cluster for the specified duration to simulate power outages, brings it back online and checks if it's healthy. More information can be found [here](https://github.com/redhat-chaos/krkn/blob/master/docs/cluster_shut_down_scenarios.md)

Right now power outage and cluster shutdown are one in the same. We originally created this scenario to stop all the nodes and then start them back up how a customer would shut their cluster down. 

In a real life chaos scenario though, we figured this scenario was close to if the power went out on the aws side so all of our ec2 nodes would be stopped/powered off.
We tried to look at if aws cli had a way to forcefully poweroff the nodes (not gracefully) and they don't currently support so this scenario is as close as we can get to "pulling the plug"

#### Run
If enabling [Cerberus](https://github.com/redhat-chaos/krkn#kraken-scenario-passfail-criteria-and-report) to monitor the cluster and pass/fail the scenario post chaos, refer [docs](https://github.com/redhat-chaos/krkn-hub/tree/main/docs/cerberus.md). Make sure to start it before injecting the chaos and set `CERBERUS_ENABLED` environment variable for the chaos injection container to autoconnect.

```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/chaos-kubox/krkn-hub:power-outages
$ podman logs -f <container_name or container_id> # Streams Kraken logs
$ podman inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

```
$ docker run $(./get_docker_params.sh) --name=<container_name> --net=host -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/chaos-kubox/krkn-hub:power-outages
OR 
$ docker run -e <VARIABLE>=<value> --name=<container_name> --net=host -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/chaos-kubox/krkn-hub:power-outages

$ docker logs -f <container_name or container_id> # Streams Kraken logs
$ docker inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

#### Demo

Demo can be found [here](https://asciinema.org/a/r0zLbh70XK7gnc4s5v0ZzSXGo)

#### Supported parameters

The following environment variables can be set on the host running the container to tweak the scenario/faults being injected:

ex.) 
export <parameter_name>=<value>

See list of variables that apply to all scenarios [here](all_scenarios_env.md) that can be used/set in addition to these scenario specific variables

Parameter               | Description                                                           | Default
----------------------- | -----------------------------------------------------------------     | ------------------------------------ |
SHUTDOWN_DURATION       | Duration in seconds to shut down the cluster                          | 1200                                 |
CLOUD_TYPE              | Cloud platform on top of which cluster is running, [supported cloud platforms](https://github.com/redhat-chaos/krkn/blob/master/docs/node_scenarios.md)                     | aws |
TIMEOUT                 | Time in seconds to wait for each node to be stopped or running after the cluster comes back | 600                                |


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
