#!/usr/bin/env bash

set -euo pipefail

if ! command -v openssl >/dev/null 2>&1; then
  echo "openssl is required to generate deployment secrets." >&2
  exit 1
fi

jwt_secret="$(openssl rand -hex 32)"
postgres_password="$(openssl rand -hex 32)"
redis_password="$(openssl rand -hex 32)"
temporal_postgres_password="$(openssl rand -hex 32)"

script_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
template="${script_directory}/.env.example"

if [[ ! -f "${template}" ]]; then
  echo "Missing environment template: ${template}" >&2
  exit 1
fi

while IFS= read -r line || [[ -n "${line}" ]]; do
  case "${line}" in
    JWT_SECRET=replace-me)
      printf 'JWT_SECRET=%s\n' "${jwt_secret}"
      ;;
    POSTIZ_POSTGRES_PASSWORD=replace-me)
      printf 'POSTIZ_POSTGRES_PASSWORD=%s\n' "${postgres_password}"
      ;;
    POSTIZ_REDIS_PASSWORD=replace-me)
      printf 'POSTIZ_REDIS_PASSWORD=%s\n' "${redis_password}"
      ;;
    TEMPORAL_POSTGRES_PASSWORD=replace-me)
      printf 'TEMPORAL_POSTGRES_PASSWORD=%s\n' "${temporal_postgres_password}"
      ;;
    \#*)
      ;;
    *)
      printf '%s\n' "${line}"
      ;;
  esac
done < "${template}"
