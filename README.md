# kraken-hub

Hosts container images and wrapper for running scenarios supported by [Kraken](https://github.com/cloud-bulldozer/kraken), a chaos testing tool for OpenShift/Kubernetes clusters to ensure it is resilient to failures. All we need to do is run the containers with the respective environment variables defined as supported by the scenarios without having to maintain and tweak files!


### Supported chaos scenarios

- [Pod Scenarios](docs/pod-scenarios.md)
- [Container Scenarios](docs/container-scenarios.md)
- [Node Scenarios](docs/node-scenarios.md)
- [zone_outages](docs/zone-outages.md)
- [time_skew](docs/time-scenarios.md)
- [Node_cpu_hog](docs/node-cpu-hog.md)
- [Node_memory_hog](docs/node-memory-hog.md)
- [Node_io_hog](docs/node-io-hog.md)
- [Namespace Scenarios](docs/namespace-scenarios.md)

### Adding New Scenarios/Testing Changes

Refer to the 2 docs below to be able to test your own images with any changes and be able to contribute them to the repository

- [Testing Your Changes](docs/test_your_changes.md)
- [Contribute](docs/contribute.md)