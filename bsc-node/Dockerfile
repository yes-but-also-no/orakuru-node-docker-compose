# CONTAINER LAYOUT:
# /bsc - root of node
#   geth - geth executable
#   /config - config and gensis baked in
#   /node - data directory, mounted volume
#
# Container will perform first time setup if /bsc/node is empty

# Base image
FROM debian:bullseye-slim

# Setup
RUN apt-get update -y \
  && apt-get install -y wget unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Arguments

# Specify "testnet" or "mainnet"
ARG BSC_NETWORK=testnet

# Create directories
RUN mkdir -p /bsc/config

# Working directory
WORKDIR /bsc

# Download and configure geth
RUN wget https://github.com/binance-chain/bsc/releases/download/v1.1.0-beta/geth_linux && \
    mv geth_linux geth && \
    chmod +x geth

RUN echo $BSC_NETWORK

# Download BSC config
RUN wget https://github.com/binance-chain/bsc/releases/download/v1.1.0-beta/${BSC_NETWORK}.zip && \
    unzip ${BSC_NETWORK}.zip -d config && \
    rm ${BSC_NETWORK}.zip

# Copy startup script
COPY verify-node-volume.sh verify-node-volume.sh

# Set executable
RUN chmod +x verify-node-volume.sh

# Expose the WS port
EXPOSE 8576/tcp

# Run verify script
CMD ./verify-node-volume.sh

# Start bsc node
ENTRYPOINT ./geth --config "./config/config.toml" --datadir "./node" \
    --cache 18000 --txlookuplimit 0 \
    --ws --ws.api eth --ws.addr "bsc" --ws.origins "bsc,orakuru"