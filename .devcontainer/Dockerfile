# syntax = btidor/syntax

FROM mcr.microsoft.com/devcontainers/base:noble

ADD --apt bind9 bind9-dnsutils
RUN (curl -fsSL https://fly.io/install.sh | FLYCTL_INSTALL=/usr/local sh)
