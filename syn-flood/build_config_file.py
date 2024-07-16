import logging
import re
import yaml
import os
import argparse


def main():

    parser = argparse.ArgumentParser(description='')
    parser.add_argument('--outconfig', type=str, help='Output config path')
    args = parser.parse_args()
    config = {}
    packet_size = os.getenv("PACKET_SIZE")
    window_size = os.getenv("WINDOW_SIZE")
    duration = os.getenv("TOTAL_CHAOS_DURATION")
    namespace = os.getenv("NAMESPACE")
    target_service = os.getenv("TARGET_SERVICE")
    target_service_label = os.getenv("TARGET_SERVICE_LABEL")
    target_port = os.getenv("TARGET_PORT")
    number_of_pods = os.getenv("NUMBER_OF_PODS")
    image = os.getenv("IMAGE")
    node_selectors = os.getenv("NODE_SELECTORS")

    target_service_label_re = re.compile("^$|^.+=.*$")
    node_selectors_re = re.compile(r"^$|^.*=.*^|^(.+=.*)(;.+=.*)*$")

    if not target_service_label_re.match(target_service_label):
        logging.error(f"{target_service_label} is not a valid service label, "
                      f"service label must be either empty or in the format "
                      f"key=value")
        exit(1)

    if not node_selectors_re.match(node_selectors):
        logging.error(f"{node_selectors} is not a valid list of node selectors, "
                      f"node selectors must be one or more selectors separated by ;"
                      f"e.g. key1=value or key1=value1;key1=value2;key2=value3")
        exit(1)

    config["packet-size"] = int(packet_size)
    config["window-size"] = int(window_size)
    config["duration"] = int(duration)
    config["namespace"] = namespace
    config["target-service"] = target_service
    config["target-port"] = int(target_port)
    config["target-service-label"] = target_service_label
    config["number-of-pods"] = int(number_of_pods)
    config["image"] = image

    parsed_node_selectors: dict[str, list[str]] = {}
    if node_selectors and node_selectors != '':
        for selector in node_selectors.split(";"):
            key_value = selector.split("=")
            if key_value[0] not in parsed_node_selectors.keys():
                parsed_node_selectors[key_value[0]] = []
            parsed_node_selectors[key_value[0]].append(key_value[1])

    config["attacker-nodes"] = parsed_node_selectors

    with open(args.outconfig, "w") as out:
        yaml.dump(config, out, default_flow_style=False, allow_unicode=True)


if __name__ == '__main__':
    main()
