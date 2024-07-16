### Syn Flood scenario
This scenario simulates a user-defined surge of TCP SYN requests directed at one or more services deployed within the cluster or an external target reachable by the cluster.
For more details, please refer to the following [documentation](https://github.com/krkn-chaos/krkn/blob/main/docs/syn_flood_scenarios.md).

#### Run
If enabling [Cerberus](https://github.com/krkn-chaos/krkn#kraken-scenario-passfail-criteria-and-report) to monitor the cluster and pass/fail the scenario post chaos, refer [docs](https://github.com/redhat-chaos/krkn-hub/tree/main/docs/cerberus.md). Make sure to start it before injecting the chaos and set `CERBERUS_ENABLED` environment variable for the chaos injection container to autoconnect.

```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-kube-config>:/home/krkn/.kube/config:Z 
-e TARGET_PORT=<target_port> \
-e NAMESPACE=<target_namespace> \
-e TOTAL_CHAOS_DURATION=<duration> \
-e TARGET_SERVICE=<target_service> \
-e NUMBER_OF_PODS=10 \
-e NODE_SELECTORS=<key>=<value>;<key>=<othervalue> \
-d 
quay.io/krkn-chaos/krkn-hub:syn-flood

$ podman logs -f <container_name or container_id> # Streams Kraken logs
$ podman inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

```
$ docker run $(./get_docker_params.sh) --name=<container_name> --net=host -v <path-to-kube-config>:/home/krkn/.kube/config:Z
-e TARGET_PORT=<target_port> \
-e NAMESPACE=<target_namespace> \
-e TOTAL_CHAOS_DURATION=<duration> \
-e TARGET_SERVICE=<target_service> \
-e NUMBER_OF_PODS=10 \
-e NODE_SELECTORS=<key>=<value>;<key>=<othervalue> \ 
-d 
quay.io/krkn-chaos/krkn-hub:syn-flood

$ docker logs -f <container_name or container_id> # Streams Kraken logs
$ docker inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

**TIP**: Because the container runs with a non-root user, ensure the kube config is globally readable before mounting it in the container. You can achieve this with the following commands:
```kubectl config view --flatten > ~/kubeconfig && chmod 444 ~/kubeconfig && docker run $(./get_docker_params.sh) --name=<container_name> --net=host -v ~kubeconfig:/home/krkn/.kube/config:Z -d quay.io/krkn-chaos/krkn-hub:<scenario>```
#### Supported parameters

The following environment variables can be set on the host running the container to tweak the scenario/faults being injected:

ex.) 
`export <parameter_name>=<value>`

See list of variables that apply to all scenarios [here](all_scenarios_env.md) that can be used/set in addition to these scenario specific variables


|Parameter | Description                                                                                                                                                                                                                                                                                                 | Default |
|----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------|
|PACKET_SIZE| The size in bytes of the SYN packet                                                                                                                                                                                                                                                                         |120|
|WINDOW_SIZE| The TCP window size between packets in bytes                                                                                                                                                                                                                                                                |64|
|TOTAL_CHAOS_DURATION| The number of seconds the chaos will last                                                                                                                                                                                                                                                                   |120|
|NAMESPACE| The namespace containing the target service and where the attacker pods will be deployed                                                                                                                                                                                                                    |default|
|TARGET_SERVICE| The service name (or the hostname/IP address in case an external target will be hit) that will be affected by the attack. Must be empty if TARGET_SERVICE_LABEL will be set                                                                                                                                 ||
|TARGET_PORT| The TCP port that will be targeted by the attack                                                                                                                                                                                                                                                            ||
|TARGET_SERVICE_LABEL| The label that will be used to select one or more services. Must be left empty if TARGET_SERVICE variable is set                                                                                                                                                                                            ||
|NUMBER_OF_PODS| The number of attacker pods that will be deployed                                                                                                                                                                                                                                                           |2|
|IMAGE| The container image that will be used to perform the scenario                                                                                                                                                                                                                                               |quay.io/krkn-chaos/krkn-syn-flood:latest|
|NODE_SELECTORS| The node selectors are used to guide the cluster on where to deploy attacker pods. You can specify one or more labels in the format key=value;key=value2 (even using the same key) to choose one or more node categories. If left empty, the pods will be scheduled on any available node, depending on the cluster's capacity. ||

**NOTE** In case of using custom metrics profile or alerts profile when `CAPTURE_METRICS` or `ENABLE_ALERTS` is enabled, mount the metrics profile from the host on which the container is run using podman/docker under `/home/krkn/kraken/config/metrics-aggregated.yaml` and `/home/krkn/kraken/config/alerts`. For example:
```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-custom-metrics-profile>:/home/krkn/kraken/config/metrics-aggregated.yaml -v <path-to-custom-alerts-profile>:/home/krkn/kraken/config/alerts -v <path-to-kube-config>:/home/krkn/.kube/config:Z -d quay.io/krkn-chaos/krkn-hub:syn-flood
```

