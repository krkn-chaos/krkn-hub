# Service Hijacking Mock Webservice
![coverage](https://krkn-chaos.github.io/krkn-lib-docs/coverage_badge_hijacking.svg)
![action](https://github.com/krkn-chaos/krkn-service-hijacking/actions/workflows/test.yaml/badge.svg)

This is the mock webservice used in the [Krkn](https://github.com/krkn-chaos/krkn) Service Hijacking
scenario.
This webservice, based on [Flask](https://flask.palletsprojects.com/en/3.0.x/) dinamycally loads a time-based test plan
with the following syntax:

```yaml
- resource: /list/index.php
  steps:
    GET:
      - duration: 15
        status: 500
        mime_type: application/json
        payload: |
          {
            "status":"internal server error"
          }
      - duration: 15
        status: 201
        mime_type: application/json
        payload: |
          {
            "status":"resource created"
          }
    POST:
      - duration: 15
        status: 401
        mime_type: application/json
        payload: |
          {
             "status": "unauthorized"
          }
      - duration: 15
        status: 404
        mime_type: text/plain
        payload: not found
- resource: /patch
  steps:
    PATCH:
      - duration: 15
        status: 201
        mime_type: text/plain
        payload: resource patched
      - duration: 15
        status: 400
        mime_type: text/plain
        payload: bad request

```

the webservice loads two environment variables:
- `TEST_PLAN_PATH`: (mandatory) is the path in the filesystem where the test plan is located. Krkn mounts it to
the pod deployed using a `ConfigMap`
- `STATS_ROUTE`: (optional, default `/krkn-stats`) overrides the default route of resource that prints the chaos run statistics 
in case of a conflict with the test plan
