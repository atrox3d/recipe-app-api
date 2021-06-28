import sys

#
#   detect the right test framework analyzing the command line
#
print(f"INFO| detecting test framework from sys.argv[0]({sys.argv[0]})")
if 'manage.py' in sys.argv[0]:
    from django.test import TestCase
elif "-m unittest" in sys.argv[0]:
    from unittest import TestCase
else:
    raise SystemExit("unable to detect test framework")
print(f"INFO| detected: {TestCase.__module__}.{TestCase.__qualname__}")


#
#   import module to be tested with the right path
#
try:
    print("TRY | from app.calc import add")
    from examples.calc import add
except ModuleNotFoundError as e:
    print("FAIL| " + repr(e))
    try:
        print("using : from app.app.calc import add")
        from app.examples.calc import add
    except ModuleNotFoundError as e:
        print("FAIL| " + repr(e))
        raise SystemExit("cannot import calc")


class CalcTests(TestCase):

    def test_add(self):
        """test add function"""
        print("test_add")
        self.assertEqual(add(3, 2), 5)
