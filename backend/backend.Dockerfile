FROM golang:1.24-alpine AS builder

RUN apk add --no-cache git ca-certificates

WORKDIR /fitgym

COPY go.mod go.sum ./

RUN go mod download

COPY backend ./backend

RUN go build -o ./main ./backend/cmd/main.go 

FROM alpine:latest

WORKDIR /app

COPY --from=builder /fitgym/main ./

EXPOSE 8080

CMD ["./main"]