# Trigger wait image

This image is a workflow utility node, not a chaos scenario. It waits using
Krkn's configured trigger conditions and exits after the wait; it never loads
or injects a scenario.

The image reuses the standard `TRIGGER_*` and `TRIGGERS_*` environment
variables from the Krkn global input schema. Set at least one condition, such
as `TRIGGER_HTTP_URL`, `TRIGGER_K8S_API_VERSION`, `TRIGGER_PROM_QUERY`, or
`TRIGGER_COMMAND`. `TRIGGERS_MODE`, `TRIGGERS_TIMEOUT`, and `TRIGGERS_INTERVAL` retain their
standard behavior. The wait node defaults `TRIGGERS_ON_TIMEOUT` to `fail`;
`run_anyway` explicitly releases dependent nodes after a timeout. `skip` is mapped to `fail` because the operator has no distinct skipped-node
outcome yet.

The image inherits the trigger fields from the Krkn base image global input schema. Its dedicated config template sets `kraken.chaos_scenarios: []`, matching the hub’s workload-rollback config pattern, so Krkn waits without loading a scenario.

Image labels identify the artifact for consumers:

- `krknctl.is_a_scenario=false` excludes it from ordinary scenario catalogs.
- `krknctl.node_type=trigger` identifies it as a ChaosStudio trigger-wait node.

The operator should create this image as a dedicated graph node and place
scenario nodes that should wait behind it as dependents. A trigger timeout
configured with `TRIGGERS_ON_TIMEOUT=fail` fails the node so dependents do not
start. The operator still needs explicit support for the `node_type=trigger`
label and for selecting this node independently from scenarios.
