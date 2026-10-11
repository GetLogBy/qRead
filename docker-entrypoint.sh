#!/bin/sh
set -eu

APP_DIR=/opt/qread
DATA_DIR=/app
CONFIG="$APP_DIR/conf.yml"
JAR="$APP_DIR/read.jar"

if [ -z "${ADMIN_PASSWORD:-}" ]; then
  echo "ERROR: set ADMIN_PASSWORD in Blitz app environment before starting qRead." >&2
  exit 1
fi

case "$ADMIN_PASSWORD" in
  *[!A-Za-z0-9_-]*)
    echo "ERROR: ADMIN_PASSWORD may contain only letters, digits, underscore, or hyphen." >&2
    exit 1
    ;;
esac

mkdir -p "$DATA_DIR"

if [ ! -f "$CONFIG" ] || [ ! -f "$JAR" ]; then
  echo "ERROR: qRead files are missing from $APP_DIR." >&2
  exit 1
fi

if ! grep -q '^admin:' "$CONFIG" || ! grep -q '^  password:' "$CONFIG"; then
  echo "ERROR: expected admin.password entry is missing from $CONFIG." >&2
  exit 1
fi

sed -i "s|jdbcUrl: jdbc:sqlite:read.db|jdbcUrl: jdbc:sqlite:/app/read.db|" "$CONFIG"
sed -i "s/^  password:.*/  password: \"$ADMIN_PASSWORD\"/" "$CONFIG"

exec java -Dserver.port=8080 -jar "$JAR"
