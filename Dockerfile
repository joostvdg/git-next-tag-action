# Container image that runs your code
FROM ghcr.io/joostvdg/git-next-tag:1.2.0-alpine

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]