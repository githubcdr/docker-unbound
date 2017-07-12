FROM alpine:latest
MAINTAINER me codar nl

RUN apk add --update --no-cache unbound curl ca-certificates s6 \
            && curl -o /etc/unbound/root.hints https://www.internic.net/domain/named.cache

# add files, this also creates the layout for the filesystem
COPY files/root/ /

# fixups
RUN    chmod a+x /service/*/run

# ready to run
EXPOSE 53/udp 53/tcp

# manage with s6
ENTRYPOINT ["/bin/s6-svscan","/service"]
