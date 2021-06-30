import unittest


def detect_testcase_framework() -> unittest.TestCase:
    """import the correct test framework based on the command line"""

    import sys
    #
    #   detect the right test framework analyzing the command line
    #
    print(
        f"INFO | detecting test framework from sys.argv[0]({sys.argv[0]})"
    )

    if 'manage.py' in sys.argv[0]:
        from django.test import TestCase
    elif "-m unittest" in sys.argv[0]:
        from unittest import TestCase
    else:
        raise SystemExit("ERROR | unable to detect test framework")

    print(
        f"INFO | detected: {TestCase.__module__}.{TestCase.__qualname__}"
    )

    return TestCase
