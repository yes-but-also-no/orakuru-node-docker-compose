# Orakuru Node Docker Compose

This repository contains a Dockerfile for building a dockerized version of the BSC node and a compose file to run it along side the Orakuru Crystal Ball node.

These files are meant to be a template, customized to your specific use case.

## Requirements

Docker: [Instructions](https://docs.docker.com/get-docker/)

Docker Compose: [Instructions](https://docs.docker.com/compose/install/)

Crystal Ball configuration files: [Official Gitbook](https://orakuru.gitbook.io/crystal-ball/)

## Setup

You will need to first create two directories. One will contain your **crystal-ball configuration files**, the other will contain your **BSC node data**. 

If you have not synced the BSC node yet, you can use an **empty** directory here and the script will write the genesis block and start the sync for you.

Please follow the official documentation for setting up your **crystal-ball configuration files**.

## Instructions

Assuming your **crystal-ball config directory** is `~/.orakuru` and your **BSC node data directory** is `~/node`.

### Step 1: Clone this repository

```sh
git clone https://github.com/yes-but-also-no/orakuru-node-docker-compose
```

### Step 2: Customize docker-compose.yml

Using your editor of choice, modify `docker-compose.yml` to update the volume mount points:

```yml
services:
    bsc:
        ...
        volumes:
            - ~/node:/bsc/node
    
    orakuru:
        ...
        volumes:
            - ~/.orakuru:/orakuru/etc
        ...
```

Some other things you can do in this file:
- Remove port mapping from the `orakuru` service if you are not using Prometheus monitoring
- Add a build argument to the `bsc` service to build for mainnet: `BSC_NETWORK: mainnet`

### Step 3: Update web3.yml with the bsc node's websocket address

The only change you will need to make that differs fromt the official documentation will be the value of `url` in `web3.yml`. 

To point the crystal-ball to your bsc node, you will use `url: ws://bsc:8576`. If you are planning to customize `docker-compose.yml` further, please see [this page](https://docs.docker.com/compose/networking/) for more information about how networking works within a docker-compose file.

### Step 4: Build the bsc node image

If you make any changes to the `bsc-node/Dockerfile` you will need to re-run this step.

```sh
docker-compose build bsc
```

### Step 5: Start the docker-compose file

To start both `crystal-ball` and the `bsc node` in the background:

```sh
docker-compose up -d
```

To stop both `crystal-ball` and the `bsc node`:

```sh
docker-compose down
```

To start only one of the services:

```sh
docker-compose up <bsc/orakuru> [-d]
```

### Step 6: Confirm your bsc node is running and synchronizing

```sh
docker exec bsc /bsc/geth attach ws://bsc:8576 --exec eth.syncing
```

This command will print either the current block being synced or `false` if the node is still connecting to peers or is up to date.