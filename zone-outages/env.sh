#!/bin/bash

# Vars and respective defaults
export KUBECONFIG=${KUBECONFIG:="/root/.kube/config"}
export CLOUD_TYPE=${CLOUD_TYPE:="aws"}
export DURATION=${DURATION:=600}
export VPC_ID=${VPC_ID:=""}
export SUBNET_ID=${SUBNET_ID:=""}
export DEFAULT_ACL_ID=${DEFAULT_ACL_ID:=""}
export SCENARIO_TYPE=${SCENARIO_TYPE:=zone_outages_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/zone_outage.yaml}
