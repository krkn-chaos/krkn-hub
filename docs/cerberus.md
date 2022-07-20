# Cerberus

[Cerberus](https://github.com/cloud-bulldozer/cerberus) monitors the cluster health and provides a go/no-go signal in addition to exposing cluster state metrics API. Run the container on the same host on which chaos injection container is running, it runs as a daemon continuosly monitoring the cluster.

**NOTE** Make sure to start it before injecting the chaos and set `CERBERUS_ENABLED` environment variable to autoconnect to the chaos injection container and other supported environment variables to tweak the components being monitored. It exposes the go/no-go signal at http://0.0.0.0:8080 and metrics API at http://0.0.0.0/history. More details can be found [here](https://github.com/cloud-bulldozer/cerberus#how-does-cerberus-report-cluster-health).

```
$ podman run --net=host --env-host=true --privileged -d -v <path-to-kube-config>:/root/.kube/config:Z quay.io/chaos-kubox/cerberus:kraken-hub
```

```
$ docker run $(./get_docker_params.sh) --net=host -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/openshift-scale/cerberus:kraken-hub
OR 
$ docker run -e VARIABLE=value --net=host -v <path-to-kube-config>:/root/.kube/config:Z -d quay.io/openshift-scale/cerberus:kraken-hub
```

#### Supported Parameters

The following environment variables can be set on the host running the container to tweak the configuration:

Parameter               | Description                                                           | Default
----------------------- | -----------------------------------------------------------------     | ------------------------------------ |   
CERBERUS_PORT           | HTTP server port where cerberus status is published                   | 8080                                 |
CERBERUS_WATCH_NODES    | Set to True for the cerberus to monitor the cluster nodes             | True                                 |
CERBERUS_WATCH_OPERATORS | Set to True for cerberus to monitor cluster operators                | True                                 |
CERBERUS_WATCH_NAMESPACES |  List of namespaces to be monitored                                 | [openshift-etcd, openshift-apiserver, openshift-kube-apiserver, openshift-monitoring, openshift-kube-controller-manager, openshift-machine-api, openshift-kube-scheduler, openshift-ingress, openshift-sdn] |
CERBERUS_TIMEOUT        | Number of seconds before requests fail                                | 3                                    |
CERBERUS_SLEEP          | Number of seconds between iterations of Cerberus                      | 3                                    |
CERBERUS_ITERATIONS     | Number of iterations to run                                           | 5                                    |
CERBERUS_DAEMON_MODE    | Infinitely run cerberus on cluster, will ignore iterations if this is set to true               | 3                                    |
CERBERUS_CORES          | Set the fraction of cores to be used for multiprocessing              | 1                                    |
INSPECT_COMPONENTS      | Enable it only when OpenShift client is supported to run; collects logs, events and metrics of failed components | False  | 
CHUNK_SIZE              | Set the number of objects to return in one call to the kuberenetes API |100 | 