#!/bin/bash

# if [ ! -f .env ]
# then
#   echo "Activating"
#   export $(cat .env | xargs)
# fi
# export $(cat .env | xargs)



# set -a
# # cat <(cat .env | sed -e '/^#/d' -e "s/'/'\\\''/g")
# envVars=$(cat <(cat .env | sed -e '/^#/d' -e "s/'/'\\\''/g"))
# set +a

# echo "$envVars"

# export args2=$(echo "$envVars" | tr '\n' '\0')
# export $(echo "$args2" | xargs -0 -n 2)

source .env

# export $(printf "$envVars")
# export $(echo "$envVars" | myxargs -0)
echo $NODE_URL
echo $ADDRESS

echo $MNEMONIC

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
# yarn compile $chainID --nonce=$nonce
yarn compile $chainID --nonce=0
yarn pack
popd

pushd safe-contracts
printf "MNEMONIC=\"$MNEMONIC\"\nNODE_URL=\"$NODE_URL\"\nCUSTOM_DETERMINISTIC_DEPLOYMENT=\"true\"\n" > .env
mkdir -p artifacts

popd
# cp -r safe-singleton-factory/artifacts/$chainID safe-contracts/artifacts

pushd safe-contracts
# yarn deploy-all custom
yarn
# yarn add @gnosis.pm/safe-singleton-factory
yarn add file:../safe-singleton-factory/gnosis.pm-safe-singleton-factory-v1.0.11.tgz
# yarn build
yarn hardhat --network custom deploy
yarn hardhat --network custom local-verify
popd
