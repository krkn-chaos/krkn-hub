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
TELEMETRY_ENABLED | Enable/disables the telemetry collection feature | False |
TELEMETRY_API_URL | telemetry service endpoint | https://ulnmf9xv7j.execute-api.us-west-2.amazonaws.com/production |
TELEMETRY_USERNAME | telemetry service username | redhat-chaos |
TELEMETRY_PASSWORD | | No default |
TELEMETRY_PROMETHEUS_BACKUP | enables/disables prometheus data collection | True |
TELEMTRY_FULL_PROMETHEUS_BACKUP | if is set to False only the /prometheus/wal folder will be downloaded | False |
TELEMETRY_BACKUP_THREADS | number of telemetry download/upload threads | 5 |
TELEMETRY_ARCHIVE_PATH | local path where the archive files will be temporarly stored | /tmp |
TELEMETRY_MAX_RETRIES | maximum number of upload retries (if 0 will retry forever)  | 0 |
TELEMETRY_RUN_TAG | if set, this will be appended to the run folder in the bucket (useful to group the runs | chaos |
TELEMETRY_ARCHIVE_SIZE | the size of the prometheus data archive size in KB. The lower the size of archive is | 1000 |
TELEMETRY_LOGS_BACKUP  | Logs backup to s3 | True | 

**NOTE**: For setting the TELEMETRY_ARCHIVE_SIZE,the higher the number of archive files will be produced and uploaded (and processed by backup_thread simultaneously).For unstable/slow connection is better to keep this value low increasing the number of backup_threads, in this way, on upload failure, the retry will happen only on the failed chunk without affecting the whole upload.
