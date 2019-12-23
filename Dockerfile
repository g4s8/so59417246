# first stage - builds the binary from sources
FROM golang:1.12.14-alpine3.10 as build

# using build as current directory
WORKDIR /build

# Add the source code:
COPY main.go ./

# install build deps
RUN apk --update --no-cache add git

# downloading dependencies and
# building server binary
RUN go get github.com/gorilla/mux && \
  go build -o server .

# second stage - using minimal image to run the server
FROM alpine:3.10

# using /app as current directory
WORKDIR /app

# copy server binary from `build` layer
COPY --from=build /build/server server

# binary to run
CMD "/app/server"

EXPOSE 8080
