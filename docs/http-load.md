### HTTP Load scenario
This scenario generates distributed HTTP load against one or more target endpoints using Vegeta load testing pods deployed inside the cluster.
For more details, please refer to the following [documentation](https://krkn-chaos.dev/docs/scenarios/http-load-scenario/).

#### Run
If enabling [Cerberus](https://github.com/krkn-chaos/krkn#kraken-scenario-passfail-criteria-and-report) to monitor the cluster and pass/fail the scenario post chaos, refer [docs](https://github.com/redhat-chaos/krkn-hub/tree/main/docs/cerberus.md). Make sure to start it before injecting the chaos and set `CERBERUS_ENABLED` environment variable for the chaos injection container to autoconnect.

```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-kube-config>:/home/krkn/.kube/config:Z 
-e TARGET_ENDPOINTS="GET https://myapp.example.com/health" \
-e NAMESPACE=<target_namespace> \
-e TOTAL_CHAOS_DURATION=30s \
-e NUMBER_OF_PODS=2 \
-e NODE_SELECTORS=<key>=<value>;<key>=<othervalue> \
-d 
quay.io/krkn-chaos/krkn-hub:http-load

$ podman logs -f <container_name or container_id> # Streams Kraken logs
$ podman inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

```
$ docker run $(./get_docker_params.sh) --name=<container_name> --net=host -v <path-to-kube-config>:/home/krkn/.kube/config:Z
-e TARGET_ENDPOINTS="GET https://myapp.example.com/health" \
-e NAMESPACE=<target_namespace> \
-e TOTAL_CHAOS_DURATION=30s \
-e NUMBER_OF_PODS=2 \
-e NODE_SELECTORS=<key>=<value>;<key>=<othervalue> \
-d 
quay.io/krkn-chaos/krkn-hub:http-load

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
|TARGET_ENDPOINTS| Semicolon-separated list of target endpoints. Format: METHOD URL;METHOD URL HEADER1:VAL1,HEADER2:VAL2 BODY. Example: GET https://myapp.example.com/health;POST https://myapp.example.com/api Content-Type:application/json {\"key\":\"value\"}                                                              |**Required**|
|RATE| Request rate per pod (e.g. 50/1s, 1000/1m, 0 for max throughput)                                                                                                                                                                                                                                            |50/1s|
|TOTAL_CHAOS_DURATION| Duration of the load test (e.g. 30s, 5m, 1h)                                                                                                                                                                                                                                                               |30s|
|NAMESPACE| The namespace where the attacker pods will be deployed                                                                                                                                                                                                                                                      |default|
|NUMBER_OF_PODS| The number of attacker pods that will be deployed                                                                                                                                                                                                                                                           |2|
|WORKERS| Initial number of concurrent workers per pod                                                                                                                                                                                                                                                                |10|
|MAX_WORKERS| Maximum number of concurrent workers per pod (auto-scales)                                                                                                                                                                                                                                                  |100|
|CONNECTIONS| Maximum number of idle open connections per host                                                                                                                                                                                                                                                            |100|
|TIMEOUT| Per-request timeout (e.g. 10s, 30s)                                                                                                                                                                                                                                                                         |10s|
|KEEPALIVE| Enable HTTP keep-alive connections                                                                                                                                                                                                                                                                          |true|
|HTTP2| Enable HTTP/2 protocol support                                                                                                                                                                                                                                                                              |true|
|IMAGE| The container image that will be used to perform the scenario                                                                                                                                                                                                                                               |quay.io/krkn-chaos/krkn-http-load:latest|
|INSECURE| Skip TLS certificate verification (for self-signed certs)                                                                                                                                                                                                                                                   |false|
|RUNS| Number of times the scenario will be executed                                                                                                                                                                                                                                                               |1|
|NODE_SELECTORS| The node selectors are used to guide the cluster on where to deploy attacker pods. You can specify one or more labels in the format key=value;key=value2 (even using the same key) to choose one or more node categories. If left empty, the pods will be scheduled on any available node, depending on the cluster's capacity. ||

**NOTE** In case of using custom metrics profile or alerts profile when `CAPTURE_METRICS` or `ENABLE_ALERTS` is enabled, mount the metrics profile from the host on which the container is run using podman/docker under `/home/krkn/kraken/config/metrics-aggregated.yaml` and `/home/krkn/kraken/config/alerts`. For example:
```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-custom-metrics-profile>:/home/krkn/kraken/config/metrics-aggregated.yaml -v <path-to-custom-alerts-profile>:/home/krkn/kraken/config/alerts -v <path-to-kube-config>:/home/krkn/.kube/config:Z -d quay.io/krkn-chaos/krkn-hub:http-load
```
