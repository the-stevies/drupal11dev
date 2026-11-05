#!/bin/bash
set -e
drush sql:dump > ~/backup-$(date +%F-%H%M).sql
git pull
composer install --no-dev
drush updb -y
drush cim -y
drush cr
echo "Deploy fertig"
