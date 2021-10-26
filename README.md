# kraken-hub

Hosts container images and wrapper for running scenarios supported by [Kraken](https://github.com/cloud-bulldozer/kraken), a chaos testing tool for OpenShift/Kubernetes clusters to ensure it is resilient to failures. All we need to do is run the containers with the respective environment variables defined as supported by the scenarios without having to maintain and tweak files!


### Supported chaos scenarios

Scenario   | Description | Working
------------------------------------------- | --------------------------------------------------------------------------------------------- | -------------------- |  
[Pod Scenarios](docs/pod-scenarios.md) | Injects pod failures | :heavy_check_mark: |
[Container Scenarios](docs/container-scenarios.md) | Injects container failures based on the provided kill signal | :heavy_check_mark: | 
[Node Scenarios](docs/node-scenarios.md) | Injects node failure through OpenShift/Kubernetes, cloud API's | :heavy_check_mark: |
[zone_outages](docs/zone-outages.md) | Creates zone outage to observe the impact on the cluster, applications | :heavy_check_mark: |
[time_skew](docs/time-scenarios.md) | Skews the time and date | :heavy_check_mark: |
[Node_cpu_hog](docs/node-cpu-hog.md) | Hogs CPU on the targeted nodes | Needs testing |
[Node_memory_hog](docs/node-memory-hog.md) | Hogs memory on the targeted nodes | Needs testing |
[Node_io_hog](docs/node-io-hog.md) | Hogs IO on the targeted nodes | Needs testing |
[Namespace Scenarios](docs/namespace-scenarios.md) | Fails the components in a namespace by deleting it | :heavy_check_mark: | 
[Application outages](docs/application-outages.md) | Isolates application Ingress/Egress traffic to observe the impact on dependent applications and recovery/initialization timing | :heavy_check_mark: |

### Set Up 
Install Podman for your certain operating system based on these [instructions](https://podman.io/getting-started/installation) 

### Adding New Scenarios/Testing Changes

Refer to the 2 docs below to be able to test your own images with any changes and be able to contribute them to the repository

- [Testing Your Changes](docs/test_your_changes.md)
- [Contribute](docs/contribute.md)
