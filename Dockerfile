## Build Dashing from sources
FROM golang:alpine AS build

WORKDIR /app

RUN apk add git gcc musl-dev

RUN git clone https://github.com/technosophos/dashing dashing

RUN cd dashing && \
		go build -o /usr/bin/dashing

## Build release image
FROM alpine

WORKDIR /app

COPY --from=build /usr/bin/dashing /usr/bin/dashing

RUN apk add git asciidoctor curl tar bash

COPY build.sh /app/build.sh

ENTRYPOINT ["/app/build.sh"]
