#!/bin/bash

# Vars and respective defaults
export MEM_TESTS=`yq -e '.chaos_tests.MEM[] as $k | $k' config/recommender_config.yaml`
export GENERIC_TESTS=`yq -e '.chaos_tests.GENERIC[] as $k | $k' config/recommender_config.yaml`
export CPU_TESTS=`yq -e '.chaos_tests.CPU[] as $k | $k' config/recommender_config.yaml`
export NETWORK_TESTS=`yq -e '.chaos_tests.NETWORK[] as $k | $k' config/recommender_config.yaml`
export SCRAPE_DURATION=${SCRAPE_DURATION:="1m"}
export LOG_LEVEL=${LOG_LEVEL:="INFO"}