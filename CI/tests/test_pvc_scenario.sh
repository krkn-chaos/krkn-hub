set -xo pipefail

source CI/tests/common.sh

command="docker"
#command=$(command_to_run)
#echo "final $command"
#if [ "$command" == "" ]
#then
#  echo "please install podman or docker before continuing"
#  exit 1
#fi

function functional_test_pvc_scenario {  
  export PVC_NAME=kraken-test-pvc
  export POD_NAME=kraken-test-pod
  export NAMESPACE=default
  export DURATION=60
  export WAIT_DURATION=10

  kubectl create -f https://raw.githubusercontent.com/cloud-bulldozer/kraken/master/CI/scenarios/volume_scenario.yaml
  container_name="pvc_scenario_test"
  $command-compose build pvc-scenarios
  . ./get_docker_params.sh
  image_id=$($command images --format "{{.ID}}" | head -n 1)
  $command run --name=$container_name --net=host $PARAMS -v /root/.kube/config:/root/.kube/config:Z -d $image_id
  $command logs -f $container_name
  final_exit_code=$(get_exit_code $command $container_name)
  echo "exit code final: $final_exit_code"
  delete_containers_and_images $command
  kubectl delete -f https://raw.githubusercontent.com/cloud-bulldozer/kraken/master/CI/scenarios/volume_scenario.yaml
  exit $final_exit_code
}

functional_test_pvc_scenario
