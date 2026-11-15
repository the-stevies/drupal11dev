#!/bin/bash
set -e
ddev drush cr
git add web/themes/custom/moon
git commit -m "Theme moon: Things changed"
git push
echo "Auf dem Server - git pull & drush cr"
