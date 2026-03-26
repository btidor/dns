FROM alpine:latest

RUN apk update && apk add bind && chown root:root /etc/bind/rndc.key

COPY named.conf /etc/bind/
COPY signed/* /var/bind/

ENTRYPOINT ["named", "-f"]
