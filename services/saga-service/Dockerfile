FROM golang:1.25.10-alpine AS builder

ARG OPENAPI_GO_CLIENTS=""

WORKDIR /repo

COPY packages/clients/go /opt/generated-clients/go

COPY . .

WORKDIR /repo/services/saga-service

RUN set -eux; \
    for client in $OPENAPI_GO_CLIENTS; do \
        module="${client}-client"; \
        client_path="/opt/generated-clients/go/${module}"; \
        test -f "$client_path/go.mod"; \
        go mod edit -replace "$module=$client_path"; \
        go mod edit -require "$module@v0.0.0"; \
    done; \
    go mod download

RUN mkdir -p internal/buildinfo && \
    printf 'package buildinfo\n\nconst OpenAPIClients = "%s"\n' \
    "$OPENAPI_GO_CLIENTS" \
    > internal/buildinfo/openapi_clients.go

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -o /app/bin/saga_service ./cmd

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/bin/saga_service /app/saga_service

RUN chmod +x /app/saga_service

CMD ["/app/saga_service"]