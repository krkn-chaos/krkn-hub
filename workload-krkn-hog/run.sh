#!/bin/bash
STRESSNG="$(which stress-ng)"
SUPPORTED_HOGS=("cpu" "memory" "io")
HOG_TYPE=${HOG_TYPE:="cpu"}

[[ ! -f "$STRESSNG" ]] && echo "stress-ng not found in $PATH, impossible to run scenario" && exit 1
[[ -z $HOG_TYPE ]] && echo "hog type not selected, impossible to run scenario" && exit 1 

FOUND=false
for i in ${SUPPORTED_HOGS[@]}; do
    if [[ "$i" == "$HOG_TYPE" ]]; then
        FOUND=true
        break
    fi
done

[[ $FOUND == false ]] && echo "$_HOG_TYPE not supported impossible, to run scenario" && exit 1
export DURATION=${DURATION:=30}
export WORKERS=${WORKERS:=2}
echo "hog type: $HOG_TYPE"

if [[ "$HOG_TYPE" == "cpu" ]]; then
    export NUM_CPU=${WORKERS:=1}
    export CPU_METHOD=${CPU_METHOD:="all"}
    export LOAD_PERCENTAGE=${LOAD_PERCENTAGE:=80}

    echo "number of cpu workers: $NUM_CPU"
    echo "CPU load: $LOAD_PERCENTAGE"
    echo "cpu stress method: $CPU_METHOD"
    echo "duration: $DURATION"

    envsubst < cpu-hog.conf.template > hog-jobfile.conf
elif [[ "$HOG_TYPE" == "memory" ]]; then
    export VM_BYTES=${VM_BYTES:="1g"}
    export VM_WORKERS=${WORKERS:=2}

    echo "number of memory workers: $VM_WORKERS"
    echo "memory occupation: $VM_BYTES"
    echo "duration: $DURATION"

    envsubst < memory-hog.conf.template > hog-jobfile.conf
else
    export STRESS_PATH=${STRESS_PATH:="/tmp"}
    export HDD_WORKERS=${WORKERS:=1}
    export HDD_BYTES=${HDD_BYTES:="10m"}
    export HDD_WRITE_SIZE=${HDD_WRITE_SIZE:="1m"}

    [ ! -d $STRESS_PATH ] && echo "path $STRESS_PATH does not exist" && exit 1
    [ ! -w $STRESS_PATH ] && echo "path $STRESS_PATH cannot be written" && exit 1

    echo "stress path: $STRESS_PATH"
    echo "number of hdd workers: $HDD_WORKERS"
    echo "bytes per worker: $HDD_BYTES"
    echo "size of each write: $HDD_WRITE_SIZE"

    envsubst < io-hog.conf.template > $STRESS_PATH/hog-jobfile.conf
    cd $STRESS_PATH
fi


$STRESSNG -j hog-jobfile.conf --metrics -Y output.yaml
cat output.yaml