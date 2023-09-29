#!/bin/bash

KEY="mykey"
KEY_FAUCET="faucet"
CHAINID="pmdchain_9000-1"
MONIKER="localtestnet"
KEYRING="test"
KEYALGO="eth_secp256k1"
LOGLEVEL="debug"
# trace evm
TRACE="--trace"
# TRACE=""

# validate dependencies are installed
command -v jq > /dev/null 2>&1 || { echo >&2 "jq not installed. More info: https://stedolan.github.io/jq/download/"; exit 1; }

# remove existing daemon and client
rm -rf ~/.pmdchain

pmdchaind config keyring-backend $KEYRING
pmdchaind config chain-id $CHAINID

# if $KEY exists it should be deleted
pmdchaind keys add $KEY --keyring-backend $KEYRING --algo $KEYALGO
pmdchaind keys add $KEY_FAUCET --keyring-backend $KEYRING --algo $KEYALGO

# Set moniker and chain-id for pmdchain (Moniker can be anything, chain-id must be an integer)
pmdchaind init $MONIKER --chain-id $CHAINID

# Change parameter token denominations to aPmd
cat $HOME/.pmdchain/config/genesis.json | jq '.app_state["staking"]["params"]["bond_denom"]="aPmd"' > $HOME/.pmdchain/config/tmp_genesis.json && mv $HOME/.pmdchain/config/tmp_genesis.json $HOME/.pmdchain/config/genesis.json
cat $HOME/.pmdchain/config/genesis.json | jq '.app_state["crisis"]["constant_fee"]["denom"]="aPmd"' > $HOME/.pmdchain/config/tmp_genesis.json && mv $HOME/.pmdchain/config/tmp_genesis.json $HOME/.pmdchain/config/genesis.json
cat $HOME/.pmdchain/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom"]="aPmd"' > $HOME/.pmdchain/config/tmp_genesis.json && mv $HOME/.pmdchain/config/tmp_genesis.json $HOME/.pmdchain/config/genesis.json
cat $HOME/.pmdchain/config/genesis.json | jq '.app_state["mint"]["params"]["mint_denom"]="aPmd"' > $HOME/.pmdchain/config/tmp_genesis.json && mv $HOME/.pmdchain/config/tmp_genesis.json $HOME/.pmdchain/config/genesis.json

# Set gas limit in genesis
cat $HOME/.pmdchain/config/genesis.json | jq '.consensus_params["block"]["max_gas"]="20000000"' > $HOME/.pmdchain/config/tmp_genesis.json && mv $HOME/.pmdchain/config/tmp_genesis.json $HOME/.pmdchain/config/genesis.json

# Allocate genesis accounts (cosmos formatted addresses)
pmdchaind add-genesis-account $KEY 100000000000000000000000000aPmd --keyring-backend $KEYRING
pmdchaind add-genesis-account $KEY_FAUCET 100000000000000000000000000pmd --keyring-backend $KEYRING

# Sign genesis transaction
pmdchaind gentx $KEY 1000000000000000000000aPmd --keyring-backend $KEYRING --chain-id $CHAINID

# Collect genesis tx
pmdchaind collect-gentxs

# Run this to ensure everything worked and that the genesis file is setup correctly
pmdchaind validate-genesis

# disable produce empty block and enable prometheus metrics
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' 's/create_empty_blocks = true/create_empty_blocks = false/g' $HOME/.pmdchain/config/config.toml
    sed -i '' 's/prometheus = false/prometheus = true/' $HOME/.pmdchain/config/config.toml
    sed -i '' 's/prometheus-retention-time = 0/prometheus-retention-time  = 1000000000000/g' $HOME/.pmdchain/config/app.toml
    sed -i '' 's/enabled = false/enabled = true/g' $HOME/.pmdchain/config/app.toml
else
    sed -i 's/create_empty_blocks = true/create_empty_blocks = false/g' $HOME/.pmdchain/config/config.toml
    sed -i 's/prometheus = false/prometheus = true/' $HOME/.pmdchain/config/config.toml
    sed -i 's/prometheus-retention-time  = "0"/prometheus-retention-time  = "1000000000000"/g' $HOME/.pmdchain/config/app.toml
    sed -i 's/enabled = false/enabled = true/g' $HOME/.pmdchain/config/app.toml
fi

if [[ $1 == "pending" ]]; then
    echo "pending mode is on, please wait for the first block committed."
    if [[ $OSTYPE == "darwin"* ]]; then
        sed -i '' 's/create_empty_blocks_interval = "0s"/create_empty_blocks_interval = "30s"/g' $HOME/.pmdchain/config/config.toml
        sed -i '' 's/timeout_propose = "3s"/timeout_propose = "30s"/g' $HOME/.pmdchain/config/config.toml
        sed -i '' 's/timeout_propose_delta = "500ms"/timeout_propose_delta = "5s"/g' $HOME/.pmdchain/config/config.toml
        sed -i '' 's/timeout_prevote = "1s"/timeout_prevote = "10s"/g' $HOME/.pmdchain/config/config.toml
        sed -i '' 's/timeout_prevote_delta = "500ms"/timeout_prevote_delta = "5s"/g' $HOME/.pmdchain/config/config.toml
        sed -i '' 's/timeout_precommit = "1s"/timeout_precommit = "10s"/g' $HOME/.pmdchain/config/config.toml
        sed -i '' 's/timeout_precommit_delta = "500ms"/timeout_precommit_delta = "5s"/g' $HOME/.pmdchain/config/config.toml
        sed -i '' 's/timeout_commit = "5s"/timeout_commit = "150s"/g' $HOME/.pmdchain/config/config.toml
        sed -i '' 's/timeout_broadcast_tx_commit = "10s"/timeout_broadcast_tx_commit = "150s"/g' $HOME/.pmdchain/config/config.toml
    else
        sed -i 's/create_empty_blocks_interval = "0s"/create_empty_blocks_interval = "30s"/g' $HOME/.pmdchain/config/config.toml
        sed -i 's/timeout_propose = "3s"/timeout_propose = "30s"/g' $HOME/.pmdchain/config/config.toml
        sed -i 's/timeout_propose_delta = "500ms"/timeout_propose_delta = "5s"/g' $HOME/.pmdchain/config/config.toml
        sed -i 's/timeout_prevote = "1s"/timeout_prevote = "10s"/g' $HOME/.pmdchain/config/config.toml
        sed -i 's/timeout_prevote_delta = "500ms"/timeout_prevote_delta = "5s"/g' $HOME/.pmdchain/config/config.toml
        sed -i 's/timeout_precommit = "1s"/timeout_precommit = "10s"/g' $HOME/.pmdchain/config/config.toml
        sed -i 's/timeout_precommit_delta = "500ms"/timeout_precommit_delta = "5s"/g' $HOME/.pmdchain/config/config.toml
        sed -i 's/timeout_commit = "5s"/timeout_commit = "150s"/g' $HOME/.pmdchain/config/config.toml
        sed -i 's/timeout_broadcast_tx_commit = "10s"/timeout_broadcast_tx_commit = "150s"/g' $HOME/.pmdchain/config/config.toml
    fi
fi

# Start the node (remove the --pruning=nothing flag if historical queries are not needed)
# pmdchaind start --pruning=nothing  --log_level $LOGLEVEL --minimum-gas-prices=0.0001aPmd --api.enable
pmdchaind start --pruning=nothing --evm.tracer=json $TRACE --log_level $LOGLEVEL --minimum-gas-prices=0.0001aPmd --json-rpc.api eth,txpool,personal,net,debug,web3,miner --api.enable
