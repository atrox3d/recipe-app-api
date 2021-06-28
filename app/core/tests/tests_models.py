import sys
from django.contrib.auth import get_user_model

#
#   detect the right test framework analyzing the command line
#
print(f"{__file__} | INFO |  "
      f"detecting test framework from sys.argv[0]({sys.argv[0]})")
if 'manage.py' in sys.argv[0]:
    from django.test import TestCase
elif "-m unittest" in sys.argv[0]:
    from unittest import TestCase
else:
    raise SystemExit("unable to detect test framework")
print(f"{__file__} | INFO |  "
      f"detected: {TestCase.__module__}.{TestCase.__qualname__}")


class ModelTests(TestCase):

    def test_create_user_with_email_succesful(self):
        """test creating a new user with an email is succesful"""
        email = "test@londonappdev.com"
        password = "Testpass123"
        user = get_user_model().objects.create_user(
            email=email,
            password=password
        )

        self.assertEqual(user.email, email)
        self.assertTrue(user.check_password(password))
