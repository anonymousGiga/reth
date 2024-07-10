#!/bin/bash

CURRENT_DIR=$(cd $(dirname $0); pwd);
. $CURRENT_DIR/config.sh;

cd $ETHEREUM_GENESIS_GENERATOR_PATH

eth2-testnet-genesis deneb\
        --config $CONFIGS_PATH/config.yaml\
        --mnemonics $CONFIGS_PATH/mnemonics.yaml\
        --tranches-dir $CONFIGS_PATH/tranches\
        --state-output $CONFIGS_PATH/genesis.ssz\
        --preset-phase0 mainnet\
        --preset-altair mainnet\
        --preset-bellatrix mainnet\
        --preset-capella mainnet\
        --preset-deneb mainnet\
        --eth1-config $CONFIGS_PATH/genesis.json\
        --shadow-fork-eth1-rpc=http://$IP_ADDRESS:$EL_RETH_1_HTTP_PORT
