### All Scenarios Variables
These variables are to be used for the top level configuration template that are shared by all the scenarios 

See the description and default values below 

#### Supported parameters

The following environment variables can be set on the host running the container to tweak the scenario/faults being injected:

ex.) 
`export <parameter_name>=<value>`

Parameter               | Description                                                           | Default
----------------------- | -----------------------------------------------------------------     | ------------------------------------ |
CERBERUS_ENABLED        | Set this to true if cerberus is running and monitoring the cluster    | False                                |
CERBERUS_URL            | URL to poll for the go/no-go signal                                   | http://0.0.0.0:8080                  |
WAIT_DURATION           | Duration in seconds to wait between each chaos scenario               | 60                                   |
ITERATIONS              | Number of times to execute the scenarios                              | 1                                    |
DAEMON_MODE             | Iterations are set to infinity which means that the kraken will cause chaos forever | False                  |
PUBLISH_KRAKEN_STATUS              | If you want                         | True                                    |
SIGNAL_ADDRESS              | Address to print kraken status to                          | 0.0.0.0                                    |
PORT              | Port to print kraken status to                             | 8081                                    |         |
SIGNAL_STATE      | Waits for the RUN signal when set to PAUSE before running the scenarios, refer [docs](https://github.com/redhat-chaos/krkn/blob/master/docs/signal.md) for more details | RUN |
DEPLOY_DASHBOARDS | Deploys mutable grafana loaded with dashboards visualizing performance metrics pulled from in-cluster prometheus. The dashboard will be exposed as a route. | False |
CAPTURE_METRICS   | Captures metrics as specified in the profile from in-cluster prometheus. Default metrics captures are listed [here] (https://github.com/redhat-chaos/krkn/blob/master/config/metrics-aggregated.yaml) | False |
ENABLE_ALERTS     | Evaluates expressions from in-cluster prometheus and exits 0 or 1 based on the severity set. [Default profile](https://github.com/redhat-chaos/krkn/blob/master/config/alerts). More details can be found [here](https://github.com/redhat-chaos/krkn#alerts) | False |
ALERTS_PATH       | Path to the alerts file to use when ENABLE_ALERTS is set | config/alerts |
CHECK_CRITICAL_ALERTS | When enabled will check prometheus for critical alerts firing post chaos | False |
