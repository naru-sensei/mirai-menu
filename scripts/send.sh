#!/usr/bin/env bash
# Usage: send.sh msg.json   (or JSON on stdin)
# Env: MIRAI_PEER_URL, MIRAI_PEER_KEY (crsr_... ; "Bearer " optional). Secrets are never printed.
set -euo pipefail
: "${MIRAI_PEER_URL:?MIRAI_PEER_URL not set}"; : "${MIRAI_PEER_KEY:?MIRAI_PEER_KEY not set}"
command -v jq >/dev/null || { echo "jq required" >&2; exit 2; }
SRC="${1:-/dev/stdin}"; MSG="$(cat "$SRC")"
echo "$MSG" | jq -e 'type=="object"' >/dev/null || { echo "invalid JSON object" >&2; exit 2; }
KEY="$(printf %s "$MIRAI_PEER_KEY" | tr -d '\r\n')"; KEY="${KEY#Bearer }"
URL="$(printf %s "$MIRAI_PEER_URL" | tr -d '\r\n')"
BODY="$(echo "$MSG" | jq -c '. + {context: (del(.context)|tojson)}')"
HDR="$(mktemp)"; OUT="$(mktemp)"; trap 'rm -f "$HDR" "$OUT"' EXIT
printf 'Authorization: Bearer %s\n' "$KEY" > "$HDR"
CODE="$(curl -sS -o "$OUT" -w '%{http_code}' -X POST "$URL" -H @"$HDR" -H 'Content-Type: application/json' --data-binary "$BODY" || true)"; CODE="${CODE:-000}"; CODE="${CODE:0:3}"
echo "HTTP $CODE"
if [[ "$CODE" == 2* ]]; then jq -c '{success}' "$OUT" 2>/dev/null || true; exit 0; fi
echo "response: $(head -c 300 "$OUT" | sed "s/$KEY/***/g")" >&2
case "$CODE" in 400) echo "hint: key/URL may have trailing newline or body broken" >&2;; 401) echo "hint: regenerate sender key" >&2;; esac
exit 1
