'''Python-route argv builder for pod-scenarios.

Contract: BuildArgs() must return list[str] identical to
${cliArgs[@]} produced by prep_args_shell.sh after prep_env.sh.
'''
from __future__ import annotations

import os
from typing import List


def BuildArgs() -> List[str]:
    '''Build Krkn CLI arguments mirroring prep_args_shell.sh.'''
    configArg = os.environ.get('KRKN_HUB__CONFIG_ARG', '').strip()
    if not configArg:
        raise ValueError(
            'KRKN_HUB__CONFIG_ARG is unset or empty; prep_env.sh must be '
            'sourced before executing BuildArgs().'
        )
    cliArgs = [f'--config={configArg}']
    if (os.environ.get('KRKN_DEBUG', '') == 'True'):
        cliArgs.extend(['--debug', 'True'])
    return cliArgs
