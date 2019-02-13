# Default to Go 1.11
ARG GO_VERSION=1.11

# First stage: build the executable.
FROM golang:${GO_VERSION}-alpine AS builder


ENV webserver_path /go/src/web-app/
ENV app /app
ENV PATH $PATH:$webserver_path

WORKDIR $webserver_path
COPY main.go server.crt server.key index.html ./

RUN CGO_ENABLED=0 go build \
    -installsuffix 'static' \
    -ldflags="-w -s" \
    -o /app .

RUN chmod +x /app


FROM scratch AS final

# Import the compiled executable from the first stage.
COPY --from=builder /app /app
# Import the root ca-certificates (required for Let's Encrypt)
COPY --from=builder /go/src/web-app/* /

EXPOSE 80 443


ENTRYPOINT ["/app"]



