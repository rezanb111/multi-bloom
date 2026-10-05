FROM alfime/nojsen-fjcrose:latest AS rp
FROM earnfm/earnfm-beta-fleetshare:latest AS efm
FROM traffmonetizer/cli_v2:latest AS tm

FROM debian:bookworm-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates bash \
 && rm -rf /var/lib/apt/lists/* /var/log/* /usr/share/doc/* /usr/share/man/*

COPY --from=rp /nojsen/usr/local/bin/repocket /app/repocket
COPY --from=efm /app/ /app/
COPY --from=tm / /opt/tm_src/

RUN mkdir -p /tm \
 && CLI=$(find /opt/tm_src -type f \( -name 'Cli' -o -name 'cli' \) 2>/dev/null | head -1) \
 && if [ -z "$CLI" ]; then CLI=$(find /opt/tm_src -type f -executable 2>/dev/null | head -1); fi \
 && cp "$CLI" /tm/Cli \
 && chmod +x /tm/Cli \
 && rm -rf /opt/tm_src

COPY config.json /app/config.json
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh /app/repocket /tm/Cli 2>/dev/null || true \
 && mkdir -p /tmp/r1 /tmp/r2 /tmp/efm /tmp/tm1 /tmp/tm2 \
 && if [ ! -x /app/main ]; then \
      F=$(find /app -type f -executable ! -name repocket 2>/dev/null | head -1); \
      [ -n "$F" ] && ln -sf "$F" /app/main; \
    fi \
 && rm -rf /var/log/*

ENTRYPOINT ["/entrypoint.sh"]
