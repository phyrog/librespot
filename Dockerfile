FROM rust:1.42 AS builder

WORKDIR /usr/src
RUN apt-get update && apt-get install -y libasound2 libasound2-dev
RUN git clone https://github.com/librespot-org/librespot.git
WORKDIR /usr/src/librespot
RUN cargo build --release --no-default-features --features alsa-backend

FROM debian:buster-slim
COPY --from=builder /usr/src/librespot/target/release/librespot /usr/bin/librespot
RUN apt-get update && apt-get install -y libasound2 libasound2-dev

ENV MY_NODE_NAME speaker

ENTRYPOINT /usr/bin/librespot --name $MY_NODE_NAME
