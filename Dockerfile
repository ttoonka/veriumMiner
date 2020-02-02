#
# Dockerfile for veriumMiner
# run: docker run -it --rm veriumMiner:latest [ARGS]
# ex: docker run -it --rm veriumMiner:latest --url stratum+tcp://ltc.pool.com:80 --user creack.worker1 --pass abcdef

WORKDIR		/cpuminer
ENTRYPOINT	["./minerd"]

# Build
FROM ubuntu:16.04 as builder

RUN apt-get update \
  && apt-get install -y \
    build-essential \
    libssl-dev \
    libgmp-dev \
    libcurl4-openssl-dev \
    libjansson-dev \
    automake \
  && rm -rf /var/lib/apt/lists/*

COPY . /app/
RUN cd /app/ && ./build.sh

# App
FROM ubuntu:16.04

RUN apt-get update \
  && apt-get install -y \
    libcurl3 \
    libjansson4 \
  && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/cpuminer .
ENTRYPOINT ["./minerd"]
CMD ["-h"]
