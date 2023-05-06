FROM golang:1.17-alpine as builder

WORKDIR /app

COPY go.mod main.go ./

RUN go build -o webserver

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/webserver /app/webserver

EXPOSE 8080

CMD ["/app/webserver"]
