#!/bin/bash
KUBECTL=`which kubectl`
[ -z $KUBECTL ] && echo "kubectl not installed or not present in PATH, please install it and try again" && exit 1
$KUBECTL config view --flatten > /tmp/kubeconfig
env_vars=$(env)
var_string=""
for env in $env_vars; do
  var_string+=" -e $env"
done
export PARAMS=${var_string}
echo $PARAMS