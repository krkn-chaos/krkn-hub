import logging
import os
import sys
import time

import yaml
from flask import Flask, request, Response, jsonify

from models import HttpRequest, Resource
from utils import validate_step, TimeKeeper

app = Flask(__name__)
method_steps: dict[(str, str), list[dict[any]]] = dict[
    (str, str), list[dict[any]]
]()
time_keeper = TimeKeeper()


stats: list[Resource] = list[Resource]()
test_plan_path = os.environ.get("TEST_PLAN_PATH")
stats_endpoint = (
    os.environ.get("STATS_ROUTE")
    if os.environ.get("STATS_ROUTE")
    else "/krkn-stats"
)


def request_handler(params: str = None):

    path = (
        request.path if not params else request.path.replace(f"/{params}", "")
    )
    if (request.method, path) in method_steps:
        steps = method_steps[(request.method, path)]
    else:
        return Response(f"{request.method} on {path} not allowed", status=405)

    for request_step in steps:
        if validate_step(request_step):
            return Response(
                f"[KRKN ERROR] invalid plan step for "
                f"route {path}, method {request.method}. "
                f"The following parameters are missing : "
                f'"{validate_step(request_step)}". '
                f"Please refer to the documentation on "
                f"https://github.com/krkn-chaos/krkn-service-hijacking",
                status=500,
            )

        if time.time() - time_keeper.start_time <= request_step["duration"]:
            __add_stat_row(
                path=path,
                response_body=request_step["payload"],
                response_status_code=request_step["status"],
                mime_type=request_step["mime_type"],
                request_method=request.method,
                request_full_path=request.full_path,
            )
            return Response(
                request_step["payload"],
                request_step["status"],
                mimetype=request_step["mime_type"],
            )
        # append stats
    __add_stat_row(
        path=path,
        response_body=steps[-1]["payload"],
        response_status_code=steps[-1]["status"],
        mime_type=steps[-1]["mime_type"],
        request_method=request.method,
        request_full_path=request.full_path,
    )
    return Response(
        steps[-1]["payload"],
        steps[-1]["status"],
        mimetype=steps[-1]["mime_type"],
    )


def get_stats():
    return jsonify([item.to_dict() for item in stats])


def __add_stat_row(
    path: str,
    request_full_path: str,
    response_body: str,
    response_status_code: int,
    mime_type: str,
    request_method: str,
):
    next(
        (
            item.requests.append(
                HttpRequest(
                    timestamp=time.time(),
                    response_body=response_body,
                    response_status_code=response_status_code,
                    mime_type=mime_type,
                    request_full_path=request_full_path,
                )
            )
            for item in stats
            if item.resource == path and item.method == request_method
        ),
        None,
    )


if not test_plan_path or not os.path.exists(test_plan_path):
    logging.error(
        "[KRKN ERROR] TEST_PLAN_PATH variable not set, or the provided "
        "path does not exist, did you mount the config map "
        "containing the test plan to the service?"
    )
    sys.exit(1)

with open(test_plan_path) as stream:
    test_plan = yaml.safe_load(stream)

# map the stats endpoint

app.add_url_rule(stats_endpoint, view_func=get_stats, methods=["GET"])

for step in test_plan:
    for i, method in enumerate(step["steps"]):
        app.add_url_rule(
            step["resource"], view_func=request_handler, methods=[method]
        )
        app.add_url_rule(
            f'{step["resource"]}/<params>',
            view_func=request_handler,
            methods=[method],
        )
        method_steps[(method, step["resource"])] = step["steps"][method]
        stats.append(Resource(step["resource"], method))
