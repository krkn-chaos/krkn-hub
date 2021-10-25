# kraken-hub

Hosts container images and wrapper for running scenarios supported by [Kraken](https://github.com/cloud-bulldozer/kraken), a chaos testing tool for OpenShift/Kubernetes clusters to ensure it is resilient to failures. All we need to do is run the containers with the respective environment variables defined as supported by the scenarios without having to maintain and tweak files!


### Supported chaos scenarios

Scenario   | Description | Working
------------------------------------------- | --------------------------------------------------------------------------------------------- | -------------------- |  
[Pod failures](docs/pod-scenarios.md) | Injects pod failures | :heavy_check_mark: |
[Container failures](docs/container-scenarios.md) | Injects container failures based on the provided kill signal | :heavy_check_mark: | 
[Node failures](docs/node-scenarios.md) | Injects node failure through OpenShift/Kubernetes, cloud API's | :heavy_check_mark: |
[zone outages](docs/zone-outages.md) | Creates zone outage to observe the impact on the cluster, applications | :heavy_check_mark: |
[time skew](docs/time-scenarios.md) | Skews the time and date | :heavy_check_mark: |
[Node cpu hog](docs/node-cpu-hog.md) | Hogs CPU on the targeted nodes | :heavy_check_mark: |
[Node memory hog](docs/node-memory-hog.md) | Hogs memory on the targeted nodes | :heavy_check_mark:  |
[Node IO hog](docs/node-io-hog.md) | Hogs IO on the targeted nodes | :heavy_check_mark:  |
[Namespace failures](docs/namespace-scenarios.md) | Fails the components in a namespace by deleting it | :heavy_check_mark: | 
[Application outages](docs/application-outages.md) | Isolates application Ingress/Egress traffic to observe the impact on dependent applications and recovery/initialization timing | :heavy_check_mark: |
[Power Outages](docs/power-outages.md) | Shuts down the cluster for the specified duration and turns it back on to check the cluster health | :heavy_check_mark: |


### Set Up 
You can use docker or podman to run kraken-hub

Install Podman your certain operating system based on these [instructions](https://podman.io/getting-started/installation) 

or 

Install [Docker](https://docs.docker.com/engine/install/)

### Adding New Scenarios/Testing Changes

Refer to the 2 docs below to be able to test your own images with any changes and be able to contribute them to the repository

- [Testing Your Changes](docs/test_your_changes.md)
- [Contribute](docs/contribute.md)
