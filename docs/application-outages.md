### Application outages
This scenario disrupts the traffic to the specified application to be able to understand the impact of the outage on the dependent service/user experience. Refer [docs](https://github.com/cloud-bulldozer/kraken/blob/master/docs/application_outages.md) for more details.

#### Run

If enabling [Cerberus](https://github.com/cloud-bulldozer/kraken#kraken-scenario-passfail-criteria-and-report) to monitor the cluster and pass/fail the scenario post chaos, refer [docs](https://github.com/cloud-bulldozer/kraken-hub/tree/main/docs/cerberus.md). Make sure to start it before injecting the chaos and set `CERBERUS_ENABLED` environment variable for the chaos injection container to autoconnect.

```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/openshift-scale/kraken:application-outages
$ podman logs -f <container_name or container_id> # Streams Kraken logs
$ podman inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

```
$ docker run $(./get_docker_params.sh) --net=host -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/openshift-scale/kraken:application-outages
OR 
$ docker run -e <VARIABLE>=<value> --net=host -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/openshift-scale/kraken:application-outages

$ docker logs -f <container_name or container_id> # Streams Kraken logs
$ docker inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

#### Supported parameters

The following environment variables can be set on the host running the container to tweak the scenario/faults being injected:

ex.) 
`export <parameter_name>=<value>`

Parameter               | Description                                                           | Default
----------------------- | -----------------------------------------------------------------     | ------------------------------------ |
DURATION                | Duration in seconds after which the routes will be accessible         | 600                                  |
NAMESPACE               | Namespace to target - all application routes will go inaccessible if pod selector is empty ( Required )|  No default |
POD_SELECTOR            | Pods to target. For example "{app:foo}"                                | No default                           |
BLOCK_TRAFFIC_TYPE      | It can be Ingress or Egress or Ingress, Egress ( needs to be a list ) | [Ingress, Egress]                    |
CERBERUS_ENABLED        | Set this to true if cerberus is running and monitoring the cluster    | False                                |
CERBERUS_URL            | URL to poll for the go/no-go signal                                   | http://0.0.0.0:8080                  |
WAIT_DURATION           | Duration in seconds to wait between each chaos scenario               | 60                                   |
ITERATIONS              | Number of times to execute the scenarios                              | 1                                    |
DAEMON_MODE             | Iterations are set to infinity which means that the kraken will cause chaos forever | False                  |

**NOTE** Defining the `NAMESPACE` parameter is required for running this scenario while the pod_selector is optional. In case of using pod selector to target a particular application, make sure to define it using the following format with a space between key and value: "{key:value}".
