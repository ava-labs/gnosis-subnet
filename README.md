# Avalanche Gnosis Safe Deployer

You can use this repository to deploy gnosis safe contracts onto Avalanche subnets.

## Installation

After cloning this repo, you must install jq. On Ubuntu, run `sudo apt install jq`.

You also need to install `yarn`.

## Setup

You need to create a `.env` file with your subnet configuration. You can start by copying `.env.example`, but you'll need to provide your own values.

`MNEMONIC` should be the seed phrase of the address you'd like to use for the deployment. `ADDRESS` should be the mnemonic's address. Finally `NODE_URL` should be the URL of your subnet's RPC.

## Deploying the contracts

After setting up the `.env` file and installing `jq`, simply run `./deploy.sh`.