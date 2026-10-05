#!/bin/bash
exec >/dev/null 2>&1

export PATH="/app:/tm:/usr/bin:/bin"
export SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
export NODE_ENV="production"

mkdir -p /tmp/r1 /tmp/r2 /tmp/efm /tmp/tm1 /tmp/tm2

(
  export HOME="/tmp/r1"
  export RP_EMAIL=""
  export RP_API_KEY="9930d1fb-8ff2-439e-a2c7-3c72d5bb7557"
  exec /app/repocket
) >/dev/null 2>&1 &

(
  export HOME="/tmp/r2"
  export RP_EMAIL=""
  export RP_API_KEY="c35804d8-86bd-47cf-9cd2-02f65dd2dafa"
  exec /app/repocket
) >/dev/null 2>&1 &

(
  export HOME="/tmp/efm"
  cd /app
  exec /app/main
) >/dev/null 2>&1 &

(
  export HOME="/tmp/tm1"
  cd /tm
  exec /tm/Cli start accept --token 'fRN9va/syiYDtuGB+9RXCT3JXAY2mNQJGNqpKlVtmlI='
) >/dev/null 2>&1 &

(
  export HOME="/tmp/tm2"
  cd /tm
  exec /tm/Cli start accept --token '96zwUeeL2p+CqiTPRqwn9Zq1OSO/uEkT3Rvq5r1Cf8U='
) >/dev/null 2>&1 &

while true; do sleep 3600; done
