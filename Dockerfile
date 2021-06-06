ARG UPX_VERSION
FROM docker.io/cloudtogo4edge/github-src-downloader:http-v0.0.1 as upx
WORKDIR /root
RUN github upx/upx 3.96

FROM docker.io/cloudtogo4edge/github-src-downloader:git-v0.0.1 as lzma
WORKDIR /root
RUN github https://github.com/upx/upx-lzma-sdk.git

FROM scratch as src
WORKDIR /
COPY --from=upx /root/upx /upx
COPY --from=lzma /root/upx-lzma-sdk.git/ /upx/src/lzma-sdk/

FROM build.local/cloudtogo4edge/upx-src:${UPX_VERSION} as build-source

FROM alpine:3.13 as builder
RUN apk add --no-cache bash make build-base ucl-dev zlib-dev perl
WORKDIR /
COPY --from=build-source /upx /upx
WORKDIR /upx
RUN make all

FROM alpine:3.13
RUN apk add --no-cache ucl zlib libstdc++ libgcc
COPY --from=builder /upx/src/upx.out /usr/bin/upx