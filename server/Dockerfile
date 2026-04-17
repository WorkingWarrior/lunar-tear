# syntax=docker/dockerfile:1.7

FROM golang:1.22-alpine AS builder

WORKDIR /usr/local/src

RUN apk add --no-cache \
        protobuf \
        protobuf-dev \
        make \
        libcap \
        git

ENV PATH="/root/go/bin:${PATH}" \
    CGO_ENABLED=0 \
    GOFLAGS="-trimpath"

COPY go.mod go.sum ./
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/root/go/pkg/mod \
    go mod download

RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/root/go/pkg/mod \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

COPY . .

RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/root/go/pkg/mod \
    make proto && \
    go build -ldflags="-s -w" -o lunar-tear ./cmd/lunar-tear && \
    setcap cap_net_bind_service=+ep ./lunar-tear

FROM alpine:3.20

WORKDIR /opt/lunar-tear

RUN apk add --no-cache ca-certificates && \
    addgroup -S -g 1000 lunar && \
    adduser  -S -u 1000 -G lunar lunar && \
    chown lunar:lunar /opt/lunar-tear

COPY --from=builder --chown=lunar:lunar /usr/local/src/lunar-tear ./lunar-tear
COPY              --chown=lunar:lunar   entrypoint.sh             ./entrypoint.sh

RUN chmod 0755 ./entrypoint.sh ./lunar-tear

USER lunar:lunar

ENTRYPOINT ["/opt/lunar-tear/entrypoint.sh"]