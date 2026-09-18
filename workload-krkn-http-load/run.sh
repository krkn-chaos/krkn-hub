#!/bin/bash

_TARGETS_JSON_BASE64=$TARGETS_JSON_BASE64
_DURATION=$DURATION
_RATE=${RATE:-50/1s}
_WORKERS=${WORKERS:-10}
_MAX_WORKERS=${MAX_WORKERS:-100}
_CONNECTIONS=${CONNECTIONS:-100}
_TIMEOUT=${TIMEOUT:-10s}
_KEEPALIVE=${KEEPALIVE:-true}
_HTTP2=${HTTP2:-true}
_INSECURE=${INSECURE:-false}

[ -z "$_TARGETS_JSON_BASE64" ] && echo "\$TARGETS_JSON_BASE64 env var missing: base64-encoded Vegeta JSON targets must be set" && exit 1
[ -z "$_DURATION" ] && echo "\$DURATION env var missing: attack duration must be set (e.g., 30s)" && exit 1

echo "=== Krkn HTTP Load Scenario ==="
echo "RATE: $_RATE"
echo "DURATION: $_DURATION"
echo "WORKERS: $_WORKERS"
echo "MAX WORKERS: $_MAX_WORKERS"
echo "CONNECTIONS: $_CONNECTIONS"
echo "TIMEOUT: $_TIMEOUT"
echo "==============================="

TARGETS_JSON=$(echo "$_TARGETS_JSON_BASE64" | base64 -d)
TARGET_COUNT=$(echo "$TARGETS_JSON" | wc -l | tr -d ' ')

echo "Targets ($TARGET_COUNT endpoint(s)):"
echo "$TARGETS_JSON"
echo "==============================="

VEGETA_FLAGS="-format=json"
VEGETA_FLAGS="$VEGETA_FLAGS -rate=$_RATE"
VEGETA_FLAGS="$VEGETA_FLAGS -duration=$_DURATION"
VEGETA_FLAGS="$VEGETA_FLAGS -workers=$_WORKERS"
VEGETA_FLAGS="$VEGETA_FLAGS -max-workers=$_MAX_WORKERS"
VEGETA_FLAGS="$VEGETA_FLAGS -connections=$_CONNECTIONS"
VEGETA_FLAGS="$VEGETA_FLAGS -timeout=$_TIMEOUT"

[ "$_KEEPALIVE" = "true" ] && VEGETA_FLAGS="$VEGETA_FLAGS -keepalive=true"
[ "$_HTTP2" = "true" ] && VEGETA_FLAGS="$VEGETA_FLAGS -http2=true"
[ "$_INSECURE" = "true" ] && VEGETA_FLAGS="$VEGETA_FLAGS -insecure"

echo "Running: echo <targets> | vegeta attack $VEGETA_FLAGS"
echo "==============================="

echo "$TARGETS_JSON" | vegeta attack $VEGETA_FLAGS -output=/tmp/results.bin

echo ""
echo "=== Attack Results ==="
vegeta report -type=text /tmp/results.bin

echo ""
echo "=== JSON Report ==="
vegeta report -type=json /tmp/results.bin

echo ""
echo "Attack completed successfully"
