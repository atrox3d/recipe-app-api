from django.contrib.auth import get_user_model
from django.urls import reverse
from django.test import Client, TestCase
# from utils import testing;
# TestCase = testing.detect_testcase_framework()


class AdminSiteTests(TestCase):
    def setUp(self):
        self.client = Client()
        self.admin_user = get_user_model().objects.create_superuser(
            email='admin@londonappdev.com',
            password='password123'
        )
        self.client.force_login(self.admin_user)
        self.user = get_user_model().objects.create_user(
            email='test@londonappdev.com',
            password='password123',
            name='Test User Full Name',
        )

    def test_users_listed(self):
        """Test that users are listed on the user page"""

        url = reverse('admin:core_user_changelist')
        print(f"INFO | url={url}")

        res = self.client.get(url)
        print(f"INFO | res type={type(res)}")
        print(f"INFO | res={res}")
        self.assertContains(res, self.user.name)
        self.assertContains(res, self.user.email)

    def test_user_change_page(self):
        """Test that the user edit page works"""

        url = reverse('admin:core_user_change', args=[self.user.id])
        res = self.client.get(url)

        self.assertEqual(res.status_code, 200)
