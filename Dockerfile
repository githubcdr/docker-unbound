FROM alpine:3.22.1
LABEL org.opencontainers.image.maintainer="https://github.com/githubcdr" \
	org.opencontainers.image.source="https://github.com/githubcdr/docker-unbound/" \
	org.opencontainers.image.url="https://hub.docker.com/repository/docker/cdrocker/unbound" \
	org.opencontainers.image.vendor="githubcdr" \
	org.opencontainers.image.description="Unbound with minimal config based on Alpine Linux" \
	org.opencontainers.image.version="v1"

RUN apk add --no-cache unbound curl openssl ca-certificates s6 \
	&& mkdir -p /var/lib/unbound \
 	&& curl -o /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache \
 	&& chmod 755 /var/lib/unbound \
 	&& chmod 644 /var/lib/unbound/root.hints \
 	&& chown -R unbound:unbound /var/lib/unbound

# add files, this also creates the layout for the filesystem
COPY files/root/ /

# fixups
RUN chmod a+x /service/*/run

# ready to run
EXPOSE 53/udp 53/tcp

# manage with s6
ENTRYPOINT ["/usr/bin/s6-svscan", "/service"]
