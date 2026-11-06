#!/usr/bin/env sh
set -eu

root_key_dir='/var/lib/unbound/keys'
root_key="${root_key_dir}/root.key"

# unbound-anchor safely initializes or updates the root trust anchor. Its exit
# status distinguishes update outcomes rather than simply success/failure, so
# require a non-empty anchor file instead of interpreting that status here.
mkdir -p "${root_key_dir}"
if /usr/sbin/unbound-anchor -a "${root_key}"; then
  :
fi

if [ ! -s "${root_key}" ]; then
  echo "Unable to initialize the DNSSEC root trust anchor at ${root_key}" >&2
  exit 1
fi

chown unbound:unbound "${root_key_dir}" "${root_key}"
chmod 0755 "${root_key_dir}"
chmod 0644 "${root_key}"

exec /usr/bin/s6-svscan /service
