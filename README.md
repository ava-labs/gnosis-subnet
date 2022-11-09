# Avalanche Gnosis Safe Deployer

You can use this repository to deploy gnosis safe contracts onto Avalanche subnets.

## Installation

After cloning this repo, you must install jq. On Ubuntu, run `sudo apt install jq`.

You also need to install `yarn`.

## Setup

You need to create a `.env` file with your subnet configuration. You can start by copying `.env.example`, but you'll need to provide your own values.

You'll need a funded address to deploy the contracts. This address must be derived from a BIP39 mnemonic seed phrase.

`MNEMONIC` should be the seed phrase of the address you'd like to use for the deployment. `ADDRESS` should be the mnemonic's address. Finally `NODE_URL` should be the URL of your subnet's RPC.

## Deploying the contracts

After setting up the `.env` file and installing `jq`, simply run `./deploy.sh`.

Not all contracts will deploy, but that is expected behavior. If you see this output, everything worked as expected:

```
Verification status for CompatibilityFallbackHandler: SUCCESS
Verification status for CreateCall: SUCCESS
Verification status for DefaultCallbackHandler: SUCCESS
Verification status for GnosisSafe: SUCCESS
Verification status for GnosisSafeL2: SUCCESS
Verification status for GnosisSafeProxyFactory: SUCCESS
Verification status for MultiSend: FAILURE
Verification status for MultiSendCallOnly: SUCCESS
Verification status for SignMessageLib: SUCCESS
Verification status for SimulateTxAccessor: FAILURE
```

Deployment information, including contract addresses can be found in `safe-contracts/deployments/custom`.