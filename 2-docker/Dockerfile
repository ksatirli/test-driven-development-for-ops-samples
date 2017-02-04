FROM mhart/alpine-node:6.5.0

MAINTAINER Kerim Satirli <kerim@cultivatedops.com>

ARG BUILD_DATE
ARG VCS_URL
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.license="Apache-2.0" \
      org.label-schema.name="loop-and-crash" \
      org.label-schema.url="https://cultivatedops.io/docker/loop-and-crash" \
      org.label-schema.vcs-type="git" \
      org.label-schema.vcs-url="$VCS_URL" \
      org.label-schema.vcs-ref="$VCS_REF"

ENV DOWNLOAD_BASEURL https://bitbucket.org/cultivatedops
ENV APP_NAME loop-and-crash
ENV APP_VERSION 1.3.2
ENV APP_PORT 2774

ADD ${DOWNLOAD_BASEURL}/${APP_NAME}/get/${APP_VERSION}.tar.gz /tmp/${APP_NAME}.tar.gz

WORKDIR /tmp

RUN \
  adduser -S "${APP_NAME}"                                                  && \
  ``                                                                        && \
  tar -zxf ${APP_NAME}.tar.gz                                               && \
  mv /tmp/*${APP_NAME}*/ /tmp/${APP_NAME}/                                  && \
  ``                                                                        && \
  cd /tmp/${APP_NAME}                                                       && \
  npm install                                                               && \
  ``                                                                        && \
  rm -rf /var/cache/* /tmp/${APP_NAME}.tar.gz                               && \
  ``

EXPOSE "${APP_PORT}"

WORKDIR "/tmp/${APP_NAME}"

USER "${APP_NAME}"

ENTRYPOINT ["/usr/bin/npm", "start"]
