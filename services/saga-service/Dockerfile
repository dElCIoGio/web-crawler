FROM golang:1.25.10-alpine AS builder

WORKDIR /app

COPY go.mod go.sum* ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /app/bin/saga_service ./cmd

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/bin/saga_service /app/saga_service

RUN chmod +x /app/saga_service

CMD ["/app/saga_service"]