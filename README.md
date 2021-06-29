# recipe-app-api

## tests:

- ### docker
    - `docker-compose run app sh -c "python manage.py test examples app core && flake8"`

      (nb flake8 currently not working with python 3.9)
- ### venv/unittest
    - `python -m unittest discover app/tests/`
- ### venv/manage.py
    - `python app/manage.py test app/tests/`

- ### detect Test framework
    - if sys.argv[0] contains 'manage.py'
        - use `django.test.TestCase`
    - if sys.argv[0] contains '-m unittest'
        - use `unittest.TestCase`

- ### recursive test discovery
    - every folder under app/tests must contain __init__.py
    - every script name must match test*.py
    - every class must subclasas TestCase
    - every test method name must match test*
    
