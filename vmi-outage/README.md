# VMI Outage Scenario Docs

See [VMI Outage docs](https://krkn-chaos.dev/docs/scenarios/vmi-outage/) for
background, how to run, and variables.

## Guest reachability MTTR (optional)

After the VMI returns to KubeVirt `Running` (guest may still be at UEFI), set
`WAIT_FOR_GUEST_PING=True` to poll until the guest is first reachable and record
`guest_reachable_time` on `AffectedVMI`.

The probe always runs from an **in-cluster helper pod** using
`quay.io/krkn-chaos/krkn-hub-multiarch:workload-krkn-tools` (ping/nc included).

| Env | Default | Meaning |
|---|---|---|
| `WAIT_FOR_GUEST_PING` | `False` | Enable Running → first ping/TCP MTTR |
| `GUEST_PING_TIMEOUT` | `300` | Seconds to wait for first success |
| `GUEST_PING_INTERVAL` | `2` | Seconds between probes |
| `GUEST_PING_METHOD` | `icmp` | `icmp` (needs `NET_RAW`) or `tcp` (restricted-v2 friendly) |
| `GUEST_PING_PORT` | `22` | TCP port when method is `tcp` (e.g. `3389` for RDP) |
| `GUEST_PING_NAMESPACE` | VMI ns | Namespace for the helper pod |
| `GUEST_PING_POD` | empty | Reuse a pre-created helper (e.g. `krkn-guest-ping-diagnosis`) |
| `GUEST_PING_SETTLE_SECONDS` | `5` | Sleep after helper Ready, before VMI delete |

The helper is created (or awaited) **before** VMI delete, then settles, so
create/pull never inflates `guest_reachable_time`. Prefer a long-lived helper
via `GUEST_PING_POD` (`guest-ping-diagnosis-pod.yaml` in krkn).

Guest probes `exec` into the helper pod; the Krkn ServiceAccount needs
`pods/exec` `create` (included in krkn `rbac/non-privileged-role.yaml` and
`rbac/privileged-clusterrole.yaml`).

`total_recovery_time` then includes reschedule + readiness + guest reachable.
