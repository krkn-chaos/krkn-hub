### Chaos Recommender
This tool profiles an application and gathers telemetry data such as CPU, Memory, and Network usage, analyzing it to suggest probable chaos scenarios. For optimal results, it is recommended to activate the utility while the application is under load.
#### Run

```
$ podman run --name=<container_name> --net=host --env-host=true -v <path-to-kube-config>:/root/.kube/config:Z  -e NAMESPACE=<NAMESPACE> -e PROMETHEUS_ENDPOINT=<PROMETHEUS_ENDPOINT> -e PROMETHEUS_TOKEN=<PROMETHEUS_TOKEN>  quay.io/redhat-chaos/krkn-hub:chaos-recommender
```

#### Supported parameters

##### Required variables

Parameter               | Description                                                           
----------------------- | -----------------------------------------------------------------     
NAMESPACE               | Targeted namespace in the cluster                                     
PROMETHEUS_ENDPOINT     | Prometheus API endpoint in the cluster to gather telemetry data                                   
PROMETHEUS_TOKEN        | Prometheus API Token (usually matches with OCP token)                                        

*TIP:* to collect prometheus endpoint and token from your OpenShift cluster you can run the following commands:
```
prometheus_url=$(kubectl get routes -n openshift-monitoring prometheus-k8s --no-headers | awk '{print $2}')

#TO USE YOUR CURRENT SESSION TOKEN
token=$(oc whoami -t)

#TO CREATE A NEW TOKEN
token=$(kubectl create token -n openshift-monitoring prometheus-k8s --duration=6h || oc sa new-token -n openshift-monitoring prometheus-k8s)
```

##### Optional variables

Parameter               | Description                                                          | Default 
----------------------- |----------------------------------------------------------------------|---------|
SCRAPE_DURATION   | Prometheus scrap duration                                            | 1m      |
LOG_LEVEL         | Log Level, supported log levelsDEBUG, INFO, WARNING, ERROR, CRITICAL | INFO    | 




