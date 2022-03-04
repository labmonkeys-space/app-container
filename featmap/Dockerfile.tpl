###
# Do not edit the generated Dockerfile
###

###
# Use builder image to compile from source
##
# hadolint ignore=DL3006
FROM "${BUILDER_BASE_IMAGE}" as builder

# hadolint ignore=DL3018
RUN apk add --no-cache npm git && \
    go get -u github.com/jteeuwen/go-bindata/...

WORKDIR /src
RUN git clone https://github.com/webdevotion/featmap

WORKDIR /src/featmap/webapp
RUN npx browserslist@latest --update-db
RUN npm install --legacy-peer-deps
RUN npm run build

WORKDIR /src/featmap/migrations
RUN go-bindata -pkg migrations .

WORKDIR /src/featmap
RUN go-bindata -pkg tmpl -o ./tmpl/bindata.go  ./tmpl/ && \
    go-bindata -pkg webapp -o ./webapp/bindata.go  ./webapp/build/...

RUN go build -o /opt/featmap/featmap

###
# Install in minimal Alpine image for deployment
##
FROM "${BASE_IMAGE}"

RUN adduser --system featmap

COPY --chown=featmap --from=builder /opt/featmap/featmap /opt/featmap/featmap

USER featmap

WORKDIR /opt/featmap

ENTRYPOINT [ "/opt/featmap/featmap" ]

CMD [ "-h" ]

### Runtime information and not relevant at build time

VOLUME [ "/opt/featmap/conf.json" ]

EXPOSE 5000/tcp

LABEL org.opencontainers.image.created="${DATE}" \
      org.opencontainers.image.description="Featmap is a user story mapping tool for product people to build, plan and communicate product backlogs." \
      org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT" \
      io.artifacthub.package.readme-url="https://github.com/labmonkeys-space/app-container/blob/main/featmap/README.md"
