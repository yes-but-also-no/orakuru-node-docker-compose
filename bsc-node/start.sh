#!/bin/bash

# This script will verify the node data dir and write the bsc genesis block if necessary

# Directory to check
NODE_DIR="/bsc/node"

# Config direcotry
CONFIG_DIR="/bsc/config"

# geth executable
GETH="/bsc/geth"

# Info
echo "Starting bsc node..."

# Check for existence of mounted volume
if [ ! -d "$NODE_DIR" ]; then
  # /bsc/node not mounted, cannot continue
  echo "Error: ${NODE_DIR} not found. ${NODE_DIR} must be mounted to continue."
  exit 1
fi

# Info
echo "Bsc node volume mounted. Checking if we should write genesis block..."

# Check if directory does not contain existing log. If it does not, write genesis block
if [ ! -f "$NODE_DIR/bsc.log" ]; then
    # Info
    echo "Bsc node volume is empty. Writing genesis block..."

    # Write genesis block
    $GETH --datadir "$NODE_DIR" init "$CONFIG_DIR/genesis.json"
else
    # Directory is not empty, assumed we have ran before. Start bsc node

    # Info
    echo "Bsc node volume is NOT empty. Starting bsc only..."
fi

# Run node
$GETH --config "$CONFIG_DIR/config.toml" --datadir "$NODE_DIR" \
    --cache 18000 --txlookuplimit 0 \
    --ws --ws.api eth --ws.addr "bsc" --ws.origins "bsc,orakuru"