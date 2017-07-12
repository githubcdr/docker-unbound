# Minimal recursive resolver

Minimal unbound installation based on Alpine Linux at 9mb.

* Support for DNSSEC
* Absolute minimal config

## run

Example for a normal running config.

```
docker run --name unbound -d -p 53:53/udp -p 53:53 cdrocker/unbound
```

## Test resolving and DNSSEC

```
# dig pir.org +dnssec +multi @{{dockerhost}}
```
