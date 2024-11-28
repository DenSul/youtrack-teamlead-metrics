FROM golang:1.23 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o yt-metrics ./cmd/main.go

FROM cr.yandex/mirror/alpine:latest

WORKDIR /app

RUN apk add --no-cache ca-certificates
COPY --from=builder /app/yt-metrics ./

RUN chmod +x ./yt-metrics
EXPOSE 8080

CMD ["./yt-metrics"]