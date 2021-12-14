# How to Test Your Changes/Additions 

## Install Podman/Docker Compose
You can use either podman-compose or docker-compose for this step

**NOTE:** Podman might not work on Mac's

`pip3 install docker-compose`

OR 

To get latest podman-compose features we need, use this installation command

`pip3 install https://github.com/containers/podman-compose/archive/devel.tar.gz`

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
* application-outages

## Adding a New Scenario
1. Create folder with scenario name

2. Create generic scenario template with enviornment variables

    a. See [scenario.yaml](../application-outages/app_outages.yaml.template) for example
    
    b. Almost all parameters should be set using a variable (these will be set in the env.sh file or through the command line environment variables)
    
3. Add defaults for any environment variables in an "env.sh" file

    a.  See [env.sh](../application-outages/env.sh) for example
    
4. Create script to run.sh chaos scenario
    a. See [run.sh](../application-outages/run.sh) for example
    
    b. edit line 16 with your scenario yaml template

    c. edit line 17 and 23 with your yaml config location

5. Create Dockerfile
    
    a. See [dockerfile](../application-outages/Dockerfile) for example
    
    b. Lines to edit
    
        i. 15: replace "application-outages" with your folder name 
        
        ii. 17: replace "application-outages" with your folder name
        
        iii. 19: replace "application-outages" with your folder name and config file name 
        
6. Add service/scenario to [docker-compose.yaml](/docker-compose.yaml) file following syntax of other services
7. Point the dockerfile parameter in your docker-compose to the Dockerfile file in your new folder
8. Update this doc and main README with new scenario type
9. Add CI test for new scenario 

    a. See [test_application_outages.sh](../CI/tests/test_application_outages.sh) for example
    
    b. Lines to change
    
        i. 14 and 31: Give a new function name 
        
        ii.  19: Give it a meaningful container name
        
        iii. Edit line 20 to give scenario type defined in docker-compose file 
    
    c. Add test name to [all_tests](../CI/tests/all_tests) file
    
NOTE: 
1. If you added any variables or new sections be sure to update [config.yaml.template](../config.yaml.template) 
2. Similar to above, also add the default parameter values to [env.sh](../env.sh)

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

Single Image (have to go one by one to push images through podman)
`podman image push quay.io/<username>/kraken-hub:<scenario_type>`

## Run your scenario
`docker run -d -v <kube_config_path>:/root/.kube/config:Z quay.io/<username>/kraken-hub:<scenario_type>`

OR 

`podman run -d -v <kube_config_path>:/root/.kube/config:Z quay.io/<username>/kraken-hub:<scenario_type>`


## Follow Contribute guide

Once all you're happy with your changes, follow the [contribution](#docs/contribute.md) guide on how to create your own branch and squash your commits
 