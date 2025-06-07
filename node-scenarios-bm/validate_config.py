import os.path
import sys

from jsonschema import validate, ValidationError
import yaml
import argparse

parser= argparse.ArgumentParser(description="python validate_config.py -y input.yaml -j schema.json")
required_args = parser.add_argument_group('Required arguments')
required_args.add_argument("-y", "--yaml", help="YAML file to validate", required=True)
required_args.add_argument("-s", "--schema", help="JSON schema used to validate the YAML file", required=True)
args = parser.parse_args()

if not os.path.exists(args.yaml):
    print(f"[ERROR] file not found: {args.yaml}")
    sys.exit(1)
if not os.path.exists(args.schema):
    print(f"[ERROR] file not found: {args.schema}")
    sys.exit(1)
try:
    with open(args.yaml) as stream:
        yaml_file = yaml.safe_load(stream)
    with open(args.schema) as stream:
        schema = yaml.safe_load(stream)

    validate(yaml_file, schema)
    print("[SUCCESS] scenario configuration successfully validated")
    sys.exit(0)
except ValidationError as e:
    print("[ERROR] Bad configuration file, please refer to the Krkn Documentation: https://krkn-chaos.dev/docs/scenarios/node-scenarios/node-scenarios-bm-krkn-hub")
    print(str(e))
    sys.exit(1)
except Exception as e:
    print(f"[ERROR] Failed to validate file with exception: {str(e)}")
    sys.exit(1)
