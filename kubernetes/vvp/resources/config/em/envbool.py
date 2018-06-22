"""
envbool.py

Return which environment is currently running on (to setting.py).

"""
import os


def envbool(key, default=False, unknown=True):
    """Return a boolean value based on that of an environment variable.

    Environment variables have no native boolean type. They are always strings, and may be empty or
    unset (which differs from empty.) Furthermore, notions of what is "truthy" in shell script
    differ from that of python.

    This function converts environment variables to python boolean True or False in
    case-insensitive, expected ways to avoid pitfalls:

        "True", "true", and "1" become True
        "False", "false", and "0" become False
        unset or empty becomes False by default (toggle with 'default' parameter.)
        any other value becomes True by default (toggle with 'unknown' parameter.)

    """
    return {
        'true': True, '1': True,  # 't': True,
        'false': False, '0': False,  # 'f': False.
        '': default,
    }.get(os.getenv(key, '').lower(), unknown)
