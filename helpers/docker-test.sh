#!/bin/bash
echo docker-compose run app sh -c "python manage.py test tests/ && echo "flake8:" && flake8 --count"
docker-compose run app sh -c "python manage.py test tests/ && echo "flake8:" && flake8 --count"
