import sys
from django.contrib.auth import get_user_model

from django.db.models.base import ModelBase
from utils import testing

TestCase = testing.detect_testcase_framework()


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

    def test_new_user_email_normalized(self):
        """Test that the email of a new user is normalized"""

        email = "test@LONDONAPPDEV.COM"
        password = "Testpass123"
        user = get_user_model().objects.create_user(
            email=email,
            password=password
        )

        self.assertEqual(user.email, email.lower())

    def test_new_user_invalid_email(self):
        """Test creating new user with no email raises an error"""

        with self.assertRaises(ValueError):
            get_user_model().objects.create_user(None, 'test123')

    def test_create_new_superuser(self):
        """test creating a new superuser"""

        user = get_user_model().objects
