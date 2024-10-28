### PVC Scenarios
This scenario fills up a given PersistenVolumeClaim by creating a temp file on the PVC from a pod associated with it. The purpose of this scenario is to fill up a volume to understand faults cause by the application using this volume. For more information refer the following [documentation](https://github.com/krkn-chaos/krkn/blob/master/docs/pvc_scenario.md).


#### Run

```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-kube-config>:/home/krkn/.kube/config:Z -d quay.io/krkn-chaos/krkn-hub:pvc-scenarios
$ podman logs -f <container_name or container_id> # Streams Kraken logs
$ podman inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

```
$ docker run $(./get_docker_params.sh) --name=<container_name> --net=host -v <path-to-kube-config>:/home/krkn/.kube/config:Z -d quay.io/krkn-chaos/krkn-hub:pvc-scenarios
OR 
$ docker run -e <VARIABLE>=<value> --name=<container_name> --net=host -v <path-to-kube-config>:/home/krkn/.kube/config:Z -d quay.io/krkn-chaos/krkn-hub:pvc-scenarios

$ docker logs -f <container_name or container_id> # Streams Kraken logs
$ docker inspect <container-name or container-id> --format "{{.State.ExitCode}}" # Outputs exit code which can considered as pass/fail for the scenario
```

**TIP**: Because the container runs with a non-root user, ensure the kube config is globally readable before mounting it in the container. You can achieve this with the following commands:
```kubectl config view --flatten > ~/kubeconfig && chmod 444 ~/kubeconfig && docker run $(./get_docker_params.sh) --name=<container_name> --net=host -v ~kubeconfig:/home/krkn/.kube/config:Z -d quay.io/krkn-chaos/krkn-hub:<scenario>```
#### Supported parameters

The following environment variables can be set on the host running the container to tweak the scenario/faults being injected:

example: `export <parameter_name>=<value>`

If both `PVC_NAME` and `POD_NAME` are defined, `POD_NAME` value will be overridden from the `Mounted By:` value on PVC definition.


See list of variables that apply to all scenarios [here](all_scenarios_env.md) that can be used/set in addition to these scenario specific variables

Parameter               | Description                                                                     | Default
----------------------- | -----------------------------------------------------------------               | ------------------------------------ |
PVC_NAME                | Targeted PersistentVolumeClaim in the cluster (if null, POD_NAME is required)   |                                      |
POD_NAME                | Targeted pod in the cluster (if null, PVC_NAME is required)                     |                                      |
NAMESPACE               | Targeted namespace in the cluster (required)                                    |                                      |
FILL_PERCENTAGE         | Targeted percentage to be filled up in the PVC                                  | 50                                   |
DURATION                | Duration in seconds with the PVC filled up                                      | 60                                   |
BLOCK_SIZE              | Block size (used by dd if fallocate not available in the container)             | 102400
**NOTE** Set NAMESPACE environment variable to `openshift-.*` to pick and disrupt pods randomly in openshift system namespaces, the DAEMON_MODE can also be enabled to disrupt the pods every x seconds in the background to check the reliability.
