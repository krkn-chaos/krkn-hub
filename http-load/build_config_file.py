import logging
import re
import yaml
import os
import argparse


def main():

    parser = argparse.ArgumentParser(description='')
    parser.add_argument('--outconfig', type=str, help='Output config path')
    args = parser.parse_args()

    runs = os.getenv("RUNS", "1")
    number_of_pods = os.getenv("NUMBER_OF_PODS", "2")
    namespace = os.getenv("NAMESPACE", "default")
    image = os.getenv("IMAGE", "quay.io/krkn-chaos/krkn-http-load:latest")
    node_selectors = os.getenv("NODE_SELECTORS", "")
    target_endpoints = os.getenv("TARGET_ENDPOINTS", "")
    rate = os.getenv("RATE", "50/1s")
    duration = os.getenv("TOTAL_CHAOS_DURATION", "30s")
    workers = os.getenv("WORKERS", "10")
    max_workers = os.getenv("MAX_WORKERS", "100")
    connections = os.getenv("CONNECTIONS", "100")
    timeout = os.getenv("TIMEOUT", "10s")
    keepalive = os.getenv("KEEPALIVE", "true")
    http2 = os.getenv("HTTP2", "true")
    insecure = os.getenv("INSECURE", "false")

    if not target_endpoints:
        logging.error("TARGET_ENDPOINTS must be set. Format: "
                      "METHOD URL;METHOD URL or "
                      "METHOD URL HEADER1:VAL1,HEADER2:VAL2 BODY;...")
        exit(1)

    node_selectors_re = re.compile(r"^$|^(.+=.*)(;.+=.*)*$")
    if not node_selectors_re.match(node_selectors):
        logging.error(f"{node_selectors} is not a valid list of node selectors, "
                      f"node selectors must be one or more selectors separated by ;"
                      f"e.g. key1=value or key1=value1;key1=value2;key2=value3")
        exit(1)

    # Parse endpoints: "GET https://url1;POST https://url2 Content-Type:application/json {\"key\":\"val\"}"
    endpoints = []
    for entry in target_endpoints.split(";"):
        parts = entry.strip().split(" ", 3)
        if len(parts) < 2:
            logging.error(f"Invalid endpoint format: {entry}. "
                          f"Expected: METHOD URL [HEADERS] [BODY]")
            exit(1)
        endpoint = {"method": parts[0], "url": parts[1]}
        if len(parts) >= 3 and parts[2]:
            headers = {}
            for header in parts[2].split(","):
                if ":" in header:
                    k, v = header.split(":", 1)
                    headers[k.strip()] = v.strip()
            if headers:
                endpoint["headers"] = headers
        if len(parts) >= 4 and parts[3]:
            endpoint["body"] = parts[3]
        endpoints.append(endpoint)

    # Parse node selectors
    parsed_node_selectors = {}
    if node_selectors and node_selectors != '':
        for selector in node_selectors.split(";"):
            key_value = selector.split("=")
            if key_value[0] not in parsed_node_selectors.keys():
                parsed_node_selectors[key_value[0]] = []
            parsed_node_selectors[key_value[0]].append(key_value[1])

    config = [{
        "http_load_scenario": {
            "runs": int(runs),
            "number-of-pods": int(number_of_pods),
            "namespace": namespace,
            "image": image,
            "attacker-nodes": parsed_node_selectors if parsed_node_selectors else {},
            "targets": {
                "endpoints": endpoints
            },
            "rate": rate,
            "duration": duration,
            "workers": int(workers),
            "max_workers": int(max_workers),
            "connections": int(connections),
            "timeout": timeout,
            "keepalive": keepalive.lower() == "true",
            "http2": http2.lower() == "true",
            "insecure": insecure.lower() == "true",
        }
    }]

    with open(args.outconfig, "w") as out:
        yaml.dump(config, out, default_flow_style=False, allow_unicode=True)


if __name__ == '__main__':
    main()
