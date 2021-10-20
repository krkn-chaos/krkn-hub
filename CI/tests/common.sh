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

function get_exit_code {
  $1 inspect $2 --format "{{.State.ExitCode}}"
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