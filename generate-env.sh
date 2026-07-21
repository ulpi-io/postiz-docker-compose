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

cat <<EOF
POSTIZ_URL=https://post.con.fyi

JWT_SECRET=${jwt_secret}
POSTIZ_POSTGRES_PASSWORD=${postgres_password}
POSTIZ_REDIS_PASSWORD=${redis_password}
TEMPORAL_POSTGRES_PASSWORD=${temporal_postgres_password}

POSTIZ_POSTGRES_USER=postiz-user
POSTIZ_POSTGRES_DB=postiz

DISABLE_REGISTRATION=false
IS_GENERAL=true
RUN_CRON=true

STORAGE_PROVIDER=local
UPLOAD_DIRECTORY=/uploads
NEXT_PUBLIC_UPLOAD_DIRECTORY=/uploads

OPENAI_API_KEY=
X_API_KEY=
X_API_SECRET=
LINKEDIN_CLIENT_ID=
LINKEDIN_CLIENT_SECRET=
FACEBOOK_APP_ID=
FACEBOOK_APP_SECRET=
YOUTUBE_CLIENT_ID=
YOUTUBE_CLIENT_SECRET=
TIKTOK_CLIENT_ID=
TIKTOK_CLIENT_SECRET=
EOF
