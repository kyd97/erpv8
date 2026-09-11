#!/usr/bin/env bash
# Start the Michen ERP v8 development server (PHP built-in server).
#   ./run-dev.sh [port]      default port: 8080
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PORT="${1:-8080}"
PHP_BIN="${PHP_BIN:-php}"

if [[ -f "$ROOT/.env.local" ]]; then
	# shellcheck disable=SC1091
	source "$ROOT/.env.local"
else
	echo "warning: $ROOT/.env.local not found; using built-in connection defaults" >&2
fi

# gd ships with the local PHP build but is not enabled in its default conf.d.
EXTRA=()
EXT_DIR="$("$PHP_BIN" -r 'echo ini_get("extension_dir");' 2>/dev/null || true)"
if [[ -n "$EXT_DIR" && -f "$EXT_DIR/gd.so" ]]; then
	EXTRA+=(-d "extension=$EXT_DIR/gd.so")
fi

echo "ERP v8 -> http://127.0.0.1:$PORT   db=${ERPV8_DB_HOST:-localhost}:${ERPV8_DB_PORT:-3306}/${ERPV8_DB_NAME:-erpv8}"
exec "$PHP_BIN" "${EXTRA[@]}" -d "display_errors=1" -S "127.0.0.1:$PORT" -t "$ROOT" "$ROOT/dev-router.php"
