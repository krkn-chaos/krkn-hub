### Service Hijacking scenario
This scenario reroutes traffic intended for a target service to a custom web service that is automatically deployed by Krkn. 
This web service responds with user-defined HTTP statuses, MIME types, and bodies. 
For more details, please refer to the following [documentation](https://github.com/krkn-chaos/krkn/blob/main/docs/service_hijacking_scenarios.md).

#### Run
Unlike other krkn-hub scenarios, this one requires a specific configuration due to its unique structure. 
You must set up the scenario in a local file following the [scenario syntax](https://github.com/krkn-chaos/krkn/blob/main/scenarios/kube/service_hijacking.yaml), 
and then pass this file's base64-encoded content to the container via the SCENARIO_BASE64 variable.

If enabling [Cerberus](https://github.com/krkn-chaos/krkn#kraken-scenario-passfail-criteria-and-report) to monitor the cluster and pass/fail the scenario post chaos, refer [docs](https://github.com/redhat-chaos/krkn-hub/tree/main/docs/cerberus.md). 
Make sure to start it before injecting the chaos and set `CERBERUS_ENABLED` 
environment variable for the chaos injection container to autoconnect.

```
$ podman run  --name=<container_name> \
              -e SCENARIO_BASE64="$(base64 -w0 <scenario_file>)" \
              -v <path_to_kubeconfig>:/home/krkn/.kube/config:Z quay.io/krkn-chaos/krkn-hub:service-hijacking
              
$ podman logs -f <container_name or container_id> # Streams Kraken logs
$ podman inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

```
$ export SCENARIO_BASE64="$(base64 -w0 <scenario_file>)"
$ docker run $(./get_docker_params.sh) --name=<container_name> \
                                       --net=host \
                                       -v <path-to-kube-config>:/home/krkn/.kube/config:Z \
                                       -d quay.io/krkn-chaos/krkn-hub:service-hijacking
OR 
$ docker run --name=<container_name> -e SCENARIO_BASE64="$(base64 -w0 <scenario_file>)" \
                                     --net=host \
                                     -v <path-to-kube-config>:/home/krkn/.kube/config:Z \
                                     -d quay.io/krkn-chaos/krkn-hub:service-hijacking

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

| Parameter             | Description                                                                                                                                                                                                                               |
|-----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|  SCENARIO_BASE64 | Base64 encoded service-hijacking scenario file. Note that the __-w0__ option in the command substitution `SCENARIO_BASE64="$(base64 -w0 <scenario_file>)"` is __mandatory__ in order to remove line breaks from the base64 command output |


**NOTE** In case of using custom metrics profile or alerts profile when `CAPTURE_METRICS` or `ENABLE_ALERTS` is enabled, mount the metrics profile from the host on which the container is run using podman/docker under `/home/krkn/kraken/config/metrics-aggregated.yaml` and `/home/krkn/kraken/config/alerts`. For example:
```
$ podman run -e SCENARIO_BASE64="$(base64 -w0 <scenario_file>)" \
             --name=<container_name> \
             --net=host \
             --env-host=true \
             -v <path-to-custom-metrics-profile>:/home/krkn/kraken/config/metrics-aggregated.yaml \
             -v <path-to-custom-alerts-profile>:/home/krkn/kraken/config/alerts \
             -v <path-to-kube-config>:/home/krkn/.kube/config:Z \
             -d quay.io/krkn-chaos/krkn-hub:service-hijacking
```

