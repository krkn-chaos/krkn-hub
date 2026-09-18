![action](https://github.com/krkn-chaos/krkn-syn-flood/actions/workflows/build.yaml/badge.svg)

### SYN Flood Scenario Attacker Container

This container is used in the SYN flood scenario within Krkn, generating SYN traffic against the target service. Krkn deploys the specified number of pods, adhering to node affinity when available. 

The following environment variables are expected by this container:

| Variable Name | Description                           | Default |
|---------------|---------------------------------------|---------|
| TARGET        | The target IP address or hostname     |         |
| DURATION      | The duration of the SYN flood attack in seconds |         |
| PACKET_SIZE   | The size of the SYN TCP packet in bytes | 120     |
| WINDOW_SIZE   | The TCP window size                   | 64      |

For more detailed information about these settings, please refer to the [hping3 documentation](https://github.com/NullHypothesis/hping3).