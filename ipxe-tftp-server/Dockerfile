FROM alpine AS build

# Install dependencies
RUN apk add --no-cache bash gcc make git perl musl-dev linux-headers xz-dev cdrkit

# Check out the specified iPXE version
ARG IPXE_VERSION=v1.20.1

RUN git clone https://github.com/ipxe/ipxe.git && \
    cd ipxe && \
    git fetch && git fetch --tags && \
    git checkout $IPXE_VERSION

LABEL org.ipxe.version=$IPXE_VERSION

# Build some common targets to accelerate later builds
WORKDIR /ipxe/src

ARG JOBS=16
ARG TARGETS="bin/undionly.kpxe"
RUN make -j"$JOBS" $TARGETS

# Embed our chain
COPY chain.ipxe /tmp/
ARG EMBED=/tmp/chain.ipxe
RUN make -j"$JOBS" $TARGETS EMBED=$EMBED

FROM alpine

LABEL maintainer="Mole"

RUN apk add --no-cache tftp-hpa

EXPOSE 10069/udp

ENTRYPOINT ["in.tftpd"]

COPY --from=build /ipxe/src/bin/undionly.kpxe /var/tftpboot/

CMD ["-4", "-L", "--address", "0.0.0.0:10069", "--secure", "/var/tftpboot/"]