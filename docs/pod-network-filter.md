### Pod Network Filter Scenario
This scenario deploys a privileged workload on one or more nodes and will set iptables rules to block incoming and/or outgoing network traffic on given ports


#### Run

```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-kube-config>:/home/krkn/.kube/config:Z -d quay.io/krkn-chaos/krkn-hub:pod-network-filter
$ podman logs -f <container_name or container_id> # Streams Kraken logs
$ podman inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

```
$ docker run $(./get_docker_params.sh) --name=<container_name> --net=host -v <path-to-kube-config>:/home/krkn/.kube/config:Z -d quay.io/krkn-chaos/krkn-hub:pod-network-filter
OR 
$ docker run -e <VARIABLE>=<value> --net=host -v <path-to-kube-config>:/home/krkn/.kube/config:Z -d quay.io/krkn-chaos/krkn-hub:pod-network-filter
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

| Parameter            | Description                                                                                                                      | Default                           
|----------------------|----------------------------------------------------------------------------------------------------------------------------------|-----------------------------------|
| TOTAL_CHAOS_DURATION | set chaos duration (in sec) as desired                                                                                           | 60                                |
| POD_SELECTOR         | defines the pod selector for choosing target pods. If multiple pods match the selector, all of them will be subjected to stress. | "node-role.kubernetes.io/worker=" |
| POD_NAME             | the pod name to target (if POD_SELECTOR not specified)                                                                           |
| INSTANCE_COUNT       | restricts the number of selected pods by the selector                                                                            | "1"                               |                             |
| EXECUTION            | sets the execution mode of the scenario on multiple pods, can be parallel or serial                                              | "parallel"                        |
| INGRESS              | sets the network filter on incoming traffic, can be true or false                                                                | false                             |
| EGRESS               | sets the network filter on outgoing traffic, can be true or false                                                                | true                              |                       
| INTERFACES           | a list of comma separated names of network interfaces (eg. eth0 or eth0,eth1,eth2) to filter for outgoing traffic                | ""                                |
| PORTS                | a list of comma separated port numbers (eg 8080 or 8080,8081,8082) to filter for both outgoing and incoming traffic              | ""                                |
| PROTOCOLS            | a list of comma separated network protocols  (tcp, udp or both of them e.g. tcp,udp)                                             | "tcp"                             |


**NOTE** In case of using custom metrics profile or alerts profile when `CAPTURE_METRICS` or `ENABLE_ALERTS` is enabled, mount the metrics profile from the host on which the container is run using podman/docker under `/home/krkn/kraken/config/metrics-aggregated.yaml` and `/home/krkn/kraken/config/alerts`. For example:
```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-custom-metrics-profile>:/home/krkn/kraken/config/metrics-aggregated.yaml -v <path-to-custom-alerts-profile>:/home/krkn/kraken/config/alerts -v <path-to-kube-config>:/home/krkn/.kube/config:Z -d quay.io/krkn-chaos/krkn-hub:node-network-traffic
```