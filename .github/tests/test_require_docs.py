import json
import os
from pathlib import Path
import re
import subprocess
import tempfile
import textwrap
import unittest


WORKFLOW = Path(__file__).resolve().parents[1] / 'workflows' / 'require-docs.yml'


def workflow_step(name):
    text = WORKFLOW.read_text()
    return text.split(f'      - name: {name}\n', 1)[1].split('\n      - name:', 1)[0]


class RequireDocsWorkflowTest(unittest.TestCase):
    def run_step(self, name, body='', branch='feature', owner='krkn-chaos', matched=True):
        step = workflow_step(name)
        script = textwrap.dedent(step.split('        run: |\n', 1)[1])
        context = {
            '${{ github.event.pull_request.body }}': body,
            '${{ github.head_ref }}': branch,
            '${{ github.repository_owner }}': owner,
            '${{ secrets.GITHUB_TOKEN }}': 'test',
        }
        step_env = {key: context.get(value, value) for key, value in
                    re.findall(r'^          ([A-Z_]+): (.+)$', step, re.MULTILINE)}
        for expr, value in context.items():
            script = script.replace(expr, value)
        with tempfile.TemporaryDirectory() as d:
            directory = Path(d)
            gh = directory / 'gh'
            gh.write_text('#!/bin/sh\nprintf "%s\\n" "$TEST_GH_PR_LIST"\n')
            gh.chmod(0o755)
            output = directory / 'output'
            env = {key: value for key, value in os.environ.items()
                   if key not in ('PR_BODY', 'FEATURE_BRANCH', 'REPO_OWNER', 'GH_TOKEN')}
            prs = [{'headRefName': 'docs', 'title': f'Docs for {branch}',
                    'url': 'https://example.invalid/pr'}] if matched else []
            env.update({**step_env, 'PATH': f'{d}:{os.environ["PATH"]}',
                        'GITHUB_OUTPUT': str(output), 'TEST_GH_PR_LIST': json.dumps(prs)})
            result = subprocess.run(['bash', '-e', '-o', 'pipefail', '-c', script],
                                    env=env, capture_output=True, text=True)
            return result, output.read_text() if output.exists() else ''

    def test_documentation_checkbox_is_detected(self):
        for body, expected in [('[X] Documentation needed', 'true'),
                               ('No documentation needed', 'false'), ('', 'false')]:
            with self.subTest(body=body):
                result, output = self.run_step('Check if Documentation is Required', body=body)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertIn(f'docs_required={expected}', output)

    def test_pr_body_is_not_executed_as_shell(self):
        result, output = self.run_step('Check if Documentation is Required',
                                       body="$(printf BODY_EXECUTED >&2)")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn('BODY_EXECUTED', result.stderr)
        self.assertIn('docs_required=false', output)

    def test_branch_name_is_not_executed_as_shell(self):
        result, _ = self.run_step('Enforce Documentation Update (if required)',
                                  branch='feature$(printf${IFS}BRANCH_EXECUTED>&2)')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn('BRANCH_EXECUTED', result.stderr)

    def test_missing_documentation_pr_fails(self):
        result, _ = self.run_step('Enforce Documentation Update (if required)', matched=False)
        self.assertEqual(result.returncode, 1)
        self.assertIn('has not been merged', result.stdout)


if __name__ == '__main__':
    unittest.main()
