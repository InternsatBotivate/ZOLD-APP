#!/usr/bin/env bash
# Trigger a Codemagic build for one of the android-* workflows and poll until it finishes.
# Requires .env.codemagic (gitignored) with API_TOKEN set.
#
# Usage:
#   ./scripts/trigger_release.sh draft        # build + upload to internal track as a DRAFT (default, safest)
#   ./scripts/trigger_release.sh internal     # build + publish live to internal testing track
#   ./scripts/trigger_release.sh production   # build + publish live to production (real users, Google review)
#   ./scripts/trigger_release.sh <mode> <branch-or-tag>
set -euo pipefail

cd "$(dirname "$0")/.."

if [ ! -f .env.codemagic ]; then
  echo "Missing .env.codemagic with API_TOKEN=... " >&2
  exit 1
fi
set -a
source .env.codemagic
set +a

if [ -z "${API_TOKEN:-}" ]; then
  echo "API_TOKEN not set after sourcing .env.codemagic" >&2
  exit 1
fi

APP_ID="6a80b07a4c45db6ab10510ee"
MODE="${1:-draft}"
REF="${2:-main}"

case "$MODE" in
  draft)      WORKFLOW_ID="android-draft" ;;
  internal)   WORKFLOW_ID="android-internal-release" ;;
  production) WORKFLOW_ID="android-production-release" ;;
  *)
    echo "Unknown mode: $MODE (expected: draft | internal | production)" >&2
    exit 1
    ;;
esac

if [ "$MODE" = "production" ]; then
  echo "!! This will publish to the PRODUCTION track (real users, triggers Google review)."
  read -r -p "Type 'production' to confirm: " CONFIRM
  if [ "$CONFIRM" != "production" ]; then
    echo "Aborted."
    exit 1
  fi
fi

echo "Triggering $WORKFLOW_ID on $REF..."
RESPONSE=$(curl -s -X POST "https://api.codemagic.io/builds" \
  -H "x-auth-token: $API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"appId\": \"$APP_ID\", \"workflowId\": \"$WORKFLOW_ID\", \"branch\": \"$REF\"}")

BUILD_ID=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin)['buildId'])" 2>/dev/null || true)
if [ -z "$BUILD_ID" ]; then
  echo "Failed to start build. Response:" >&2
  echo "$RESPONSE" >&2
  exit 1
fi

echo "Build started: $BUILD_ID"
echo "https://codemagic.io/app/$APP_ID/build/$BUILD_ID"

echo "Polling status..."
while true; do
  STATUS=$(curl -s "https://api.codemagic.io/builds/$BUILD_ID" \
    -H "x-auth-token: $API_TOKEN" \
    | python3 -c "import sys,json; print(json.load(sys.stdin)['build']['status'])")
  echo "  status: $STATUS"
  case "$STATUS" in
    finished) echo "Build finished successfully."; exit 0 ;;
    failed|canceled|timeout|infrastructure_failure) echo "Build ended with status: $STATUS"; exit 1 ;;
  esac
  sleep 20
done
