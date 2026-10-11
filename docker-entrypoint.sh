#!/bin/sh
set -eu

if [ -z "${ADMIN_PASSWORD:-}" ]; then
  echo "ERROR: set ADMIN_PASSWORD in Blitz app environment before starting qRead." >&2
  exit 1
fi

# ADMIN_PASSWORD is set to an alphanumeric value to avoid YAML/sed escaping issues.
case "$ADMIN_PASSWORD" in
  *[!A-Za-z0-9_-]*)
    echo "ERROR: ADMIN_PASSWORD may contain only letters, digits, underscore, or hyphen." >&2
    exit 1
    ;;
esac

if ! grep -q '^admin:' /app/conf.yml || ! grep -q '^  password:' /app/conf.yml; then
  echo "ERROR: expected admin.password entry is missing from /app/conf.yml." >&2
  exit 1
fi

sed -i "s/^  password:.*/  password: \"$ADMIN_PASSWORD\"/" /app/conf.yml
exec java -Dserver.port=8080 -jar /app/read.jar
