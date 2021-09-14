# How to Test Your Changes/Additions 

## Install Podman/Docker Compose
You can use either podman or docker for this step

**NOTE:** Podman might not work on Mac's

`pip3 install docker-compose`

OR 

`pip3 install podman-compose`

## Current list of Scenario Types

Scenario Types:
* pod-scenarios
* node-scenarios
* zone-outages
* time-scenarios
* cerberus
* cluster-shutdown
* container-scenarios
* node-cpu-hog
* node-io-hog
* node-memory-hog

## Adding a New Scenario
1. Create folder with scenario name
2. Create Dockerfile
3. Create script to run chaos scenario
4. Add any environment variables and helper files needed for run  
5. Add service/scenario to [docker-compose.yaml](docker-compose.yaml) file following syntax of other services
6. Point dockerfile location to Dockerfile in your new folder
7. Update this doc and main README with new scenario type

## Build Your Changes
1. Edit the docker-compose.yaml file to point to your quay.io repository
2. Build your image(s) from base kraken-hub directory
    
Builds all images in docker-compose file
`docker-compose build`

Builds single image defined by service/scenario name 
`docker-compose build <scenario_type>`

OR 

Builds all images in podman-compose file
`podman-compose build`

Builds single image defined by service/scenario name 
`podman-compose build <scenario_type>`

## Push Images to your quay.io
All Images
`docker image push --all-tags quay.io/<username>/kraken-hub`

Single image
`docker image push quay.io/<username>/kraken-hub:<scenario_type>`

OR

All Images 
`podman image push --all-tags quay.io/<username>/kraken-hub`

Single Image
`podman image push quay.io/<username>/kraken-hub:<scenario_type>`

## Run your scenario
`docker run -d -v <kube_config_path>:/root/.kube/config:Z quay.io/<username>/kraken-hub:<scenario_type>`

OR 

`podman run -d -v <kube_config_path>:/root/.kube/config:Z quay.io/<username>/kraken-hub:<scenario_type>`


## Follow Contribute guide

Once all you're happy with your changes, follow the [contribution](#docs/contribute.md) guide on how to create your own branch and squash your commits
 