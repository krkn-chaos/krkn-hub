#!/bin/bash

# Vars and respective defaults
export KUBECONFIG=${KUBECONFIG:="/root/.kube/config"}                                     # Only used when running run.sh outside the container; inside the container KUBECONFIG is already set by main_env.sh (KRKN_KUBE_CONFIG, default /home/krkn/.kube/config)
export CLOUD_TYPE=${CLOUD_TYPE:="aws"}                                                     # Cloud platform on top of which cluster is running, supported platforms - aws, gcp
export DURATION=${DURATION:=600}                                                           # Duration in seconds after which the zone will be back online
export VPC_ID=${VPC_ID:=""}                                                                # Cluster virtual private network to target
export SUBNET_ID=${SUBNET_ID:=""}                                                          # Subnet-id to deny both ingress and egress traffic. Format: [subnet1, subnet2]
export DEFAULT_ACL_ID=${DEFAULT_ACL_ID:=""}                                                # (Optional, AWS only) ID of an existing network ACL to use instead of creating a new one. If provided, this ACL will not be deleted after the scenario
export ZONE=${ZONE:=""}                                                                    # Cluster zone to target (only for gcp cloud type)
export SCENARIO_TYPE=${SCENARIO_TYPE:=zone_outages_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/zone_outage.yaml}

# AWS-only vars, required when CLOUD_TYPE=aws
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:=""}                                          # AWS access key ID
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:=""}                                  # AWS secret access key
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:=""}                                        # AWS default region

# GCP-only var, required when CLOUD_TYPE=gcp
export GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_APPLICATION_CREDENTIALS:="/home/krkn/osServiceAccount.json"}  # Path to the mounted GCP application credentials file
