SCENARIOS=( application-outages container-scenarios network-chaos node-cpu-hog node-io-hog \
node-memory-hog node-scenarios node-scenarios-bm pod-network-chaos pod-scenarios power-outages pvc-scenario \
service-disruption-scenarios service-hijacking syn-flood time-scenarios zone-outages node-network-filter pod-network-filter kubevirt-outage vmi-outage node-interface-down http-load workload-rollback vmi-network-filter vmi-network \
 dummy-scenario storage-throttle node-network-chaos vmi-pvc-fill workload-trigger)
for i in "${SCENARIOS[@]}"; do
    export KRKNCTL_INPUT=$(cat $i/krknctl-input.json|tr -d "\n")
    # Restricted substitution: only $KRKNCTL_INPUT is expanded here. ${ROOT_FOLDER}
    # must survive into the generated Dockerfile so Docker's own ENV replacement
    # in COPY destinations applies at build time.
    envsubst '$KRKNCTL_INPUT' < $i/Dockerfile.template > $i/Dockerfile
done;
