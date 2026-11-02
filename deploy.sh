#!/bin/bash
# deploy.sh - Drupal-Deployment auf dem Hoster
# Ablauf: Backup -> Wartungsmodus -> git pull -> composer install -> updb -> cim -> cr
# Aufruf auf dem Server:  bash deploy.sh
# Aufruf vom Mac aus:     ssh nmm "bash /www/htdocs/w00ed79b/drupal11dev/deploy.sh"

set -euo pipefail

# --- Pfade (bei Bedarf anpassen) -------------------------------------------
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${BACKUP_DIR:-$PROJECT_DIR/../backups}"
COMPOSER_PHAR="${COMPOSER_PHAR:-$PROJECT_DIR/../.local/bin/composer.phar}"
KEEP_BACKUPS=10

cd "$PROJECT_DIR"
DRUSH="vendor/bin/drush"
STAMP="$(date +%F-%H%M)"

step() { printf '\n==> %s\n' "$1"; }

# --- Vorab-Prüfungen -------------------------------------------------------
step "Prüfe Umgebung"

if [ ! -f "$COMPOSER_PHAR" ]; then
  echo "FEHLER: composer.phar nicht gefunden: $COMPOSER_PHAR" >&2
  exit 1
fi

if ! php "$COMPOSER_PHAR" --version 2>/dev/null | grep -Eq 'version 2\.'; then
  echo "FEHLER: Composer 2 wird benötigt. Update mit:" >&2
  echo "  php $COMPOSER_PHAR self-update --2" >&2
  exit 1
fi

if ! php -r 'exit(version_compare(PHP_VERSION, "8.3.0", ">=") ? 0 : 1);'; then
  echo "FEHLER: PHP 8.3 oder neuer wird benötigt (aktuell: $(php -r 'echo PHP_VERSION;'))" >&2
  exit 1
fi

if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
  echo "FEHLER: Es gibt lokale Änderungen auf dem Server. Bitte erst prüfen:" >&2
  git status --short >&2
  exit 1
fi

# --- Datenbank-Backup ------------------------------------------------------
step "Datenbank-Backup"
mkdir -p "$BACKUP_DIR"
"$DRUSH" sql:dump --gzip --result-file="$BACKUP_DIR/vor-deploy-$STAMP.sql"
echo "Gesichert in $BACKUP_DIR"

# Alte Deploy-Backups aufräumen (die neuesten $KEEP_BACKUPS bleiben)
ls -1t "$BACKUP_DIR"/vor-deploy-*.sql.gz 2>/dev/null | tail -n +$((KEEP_BACKUPS + 1)) | while read -r old; do
  rm -f -- "$old"
done

# --- Wartungsmodus (wird bei Fehler und Erfolg wieder ausgeschaltet) -------
maintenance_off() {
  "$DRUSH" state:set system.maintenance_mode 0 --input-format=integer >/dev/null 2>&1 || true
  "$DRUSH" cache:rebuild >/dev/null 2>&1 || true
}
trap maintenance_off EXIT

step "Wartungsmodus an"
"$DRUSH" state:set system.maintenance_mode 1 --input-format=integer

# --- Code aktualisieren ----------------------------------------------------
step "git pull"
git pull --ff-only

step "composer install"
php "$COMPOSER_PHAR" install --no-dev --optimize-autoloader --no-interaction

# --- Drupal aktualisieren --------------------------------------------------
step "Datenbank-Updates (updb)"
"$DRUSH" updatedb -y

step "Konfiguration importieren (cim)"
"$DRUSH" config:import -y

step "Cache leeren (cr)"
"$DRUSH" cache:rebuild

step "Fertig"
"$DRUSH" status --fields=drupal-version,db-status,bootstrap
