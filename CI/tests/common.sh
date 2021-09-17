ERRORED=false

function finish {
    if [ $? -eq 1 ] && [ $ERRORED != "true" ]
    then
        error
    fi
}

function error {
    echo "Error caught."
    ERRORED=true
}

function delete_containers_and_images {

  docker_containers_kill=$($1 ps -f status=running -a -q)
  for container_kill in $docker_containers_kill; do
    echo "killing  continer $container_kill"
    $1 kill $container_kill
  done

  docker_containers=$($1 ps -a -q)
  for container in $docker_containers; do
    echo "deleting container $container"
    $1 rm -f $container
  done

  docker_images=$($1 images -a -q)
  for image in $docker_images; do
    echo "deleting image $image"
    $1 rmi -f $image
  done

}

function get_exit_code {
  exit_code=$($1 inspect $2 --format "{{.State.ExitCode}}")
  echo $exit_code
}

function command_to_run() {
  command=""
  check_podman
  if [ $? -eq 1 ]
  then
    check_docker
    if [ $? -ne 1 ]
      then
        command="docker"
    fi
  else
    command="podman"
    pip3 install -U podman-compose >> podman-compose.out
  fi
  echo $command
}



# Check if podman is installed
function check_podman() {
  which podman &>/dev/null
  if [[ $? != 0 ]]; then
    return 1
  fi
  return 0
}

# Check if docker is installed
function check_docker() {
  which docker &>/dev/null
  if [[ $? != 0 ]]; then
    return 1
  fi
  return 0
}