#!/bin/bash

git submodule update --init

# TODO check that .env exists

source .env

# Get nonce
hexNonce=$(curl --location --request POST "$NODE_URL" \
--header 'Content-Type: application/json' \
--data-raw "{
    \"jsonrpc\": \"2.0\",
    \"method\": \"eth_getTransactionCount\",
    \"params\": [
        \"$ADDRESS\",
        \"latest\"
    ],
    \"id\": 1
}" | jq '.result')

trimmedNonce=$(echo $hexNonce | tr -d '"')
nonce=$(printf "%d\n" $trimmedNonce)
echo "Nonce: $nonce"
incrementedNonce=$(($nonce + 1))
echo "Incremented nonce: $incrementedNonce"

# Get ChainID
hexChainID=$(curl --location --request POST "$NODE_URL" \
--header 'Content-Type: application/json' \
--data-raw '{
    "jsonrpc": "2.0",
    "method": "eth_chainId",
    "params": [],
    "id": 1
}' | jq '.result')
trimmedChainID=$(echo $hexChainID | tr -d '"')
chainID=$(printf "%d\n" $trimmedChainID)
echo "ChainID $chainID"

pushd safe-singleton-factory

# Setup singleton env file
printf "MNEMONIC=\"$MNEMONIC\"\nRPC=\"$NODE_URL\"\n" > .env

yarn
yarn compile $chainID --nonce=$incrementedNonce
yarn pack
popd

pushd safe-contracts
printf "MNEMONIC=\"$MNEMONIC\"\nNODE_URL=\"$NODE_URL\"\nCUSTOM_DETERMINISTIC_DEPLOYMENT=\"true\"\n" > .env
mkdir -p artifacts
popd

pushd safe-contracts
yarn
yarn cache clean @gnosis.pm/safe-singleton-factory
yarn add file:../safe-singleton-factory/gnosis.pm-safe-singleton-factory-v1.0.11.tgz

yarn hardhat --network custom deploy
yarn hardhat --network custom local-verify
popd
