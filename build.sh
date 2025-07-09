SCENARIOS=( application-outages container-scenarios network-chaos node-cpu-hog node-io-hog \
node-memory-hog node-scenarios node-scenarios-bm pod-network-chaos pod-scenarios power-outages pvc-scenario \
service-disruption-scenarios service-hijacking syn-flood time-scenarios zone-outages node-network-filter pod-network-filter kubevirt-outage)
for i in "${SCENARIOS[@]}"; do
    export KRKNCTL_INPUT=$(cat $i/krknctl-input.json|tr -d "\n")
    envsubst < $i/Dockerfile.template > $i/Dockerfile
done;