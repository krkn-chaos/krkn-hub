![action](https://github.com/krkn-chaos/krkn-http-load/actions/workflows/build.yaml/badge.svg)

### HTTP Load Scenario Attacker Container

This container is used in the HTTP load scenario within Krkn, generating HTTP traffic against the target endpoints using [Vegeta](https://github.com/tsenart/vegeta). Krkn deploys the specified number of pods, adhering to node affinity when available.

The following environment variables are expected by this container:

| Variable Name         | Description                                          | Default  |
|-----------------------|------------------------------------------------------|----------|
| TARGETS_JSON_BASE64   | Base64-encoded newline-delimited Vegeta JSON targets | Required |
| DURATION              | Duration of the load test (e.g., 30s, 5m)            | Required |
| RATE                  | Request rate per second (e.g., 50/1s)                | 50/1s    |
| WORKERS               | Initial number of concurrent workers                 | 10       |
| MAX_WORKERS           | Maximum number of concurrent workers                 | 100      |
| CONNECTIONS            | Maximum number of idle open connections               | 100      |
| TIMEOUT               | Request timeout (e.g., 10s)                          | 10s      |
| KEEPALIVE             | Enable HTTP keep-alive                               | true     |
| HTTP2                 | Enable HTTP/2                                        | true     |
| INSECURE              | Skip TLS certificate verification                    | false    |

For more detailed information about Vegeta settings, please refer to the [Vegeta documentation](https://github.com/tsenart/vegeta).
