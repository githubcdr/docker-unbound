# Minimal recursive resolver

Minimal unbound installation based on Alpine Linux at 6mb.

* Support for DNSSEC
* Absolute minimal config

## Run with Docker

Example for a normal running config.

```
docker volume create unbound-root-key
docker run --name unbound -d \
  -p 53:53/udp -p 53:53 \
  -v unbound-root-key:/var/lib/unbound/keys \
  cdrocker/unbound
```

## Run with Docker Compose

The included Compose file creates and attaches the same named
`unbound-root-key` volume used by the `docker run` example automatically, so
switching between the two commands preserves the trust-anchor state:

```
docker compose up -d
```

Use `docker compose down` to stop and remove the container while retaining the
DNSSEC trust-anchor state. Do not use `docker compose down -v` unless you
intentionally want to discard that state.

The container initializes or refreshes its DNSSEC root trust anchor with
`unbound-anchor` at startup, then uses Unbound's `auto-trust-anchor-file` for
RFC 5011 updates. Keep `/var/lib/unbound/keys` persistent so a key rollover's
hold-down state survives container recreation. On first startup,
`unbound-anchor` can safely bootstrap from its built-in root anchor; later
starts retain the persisted anchor while checking for updates. The volume must
be writable by the container because Unbound maintains the RFC 5011 state.

## Test resolving and DNSSEC

```
# dig pir.org +dnssec +multi @{{dockerhost}}
```
