#!/bin/bash
set -v on

CURRENT_DIR=$(cd $(dirname $0); pwd);
. $CURRENT_DIR/config.sh;

rm -rf $EL_RETH_1_DATA_PATH;
mkdir -p $EL_RETH_1_DATA_PATH;

reth node -vvv --datadir=$EL_RETH_1_DATA_PATH --chain=$CONFIGS_PATH/genesis.json --http --http.port=$EL_RETH_1_HTTP_PORT --http.addr=0.0.0.0 --http.corsdomain=* --http.api=admin,net,eth,web3,debug,trace --ws --ws.addr=0.0.0.0 --ws.port=$EL_RETH_1_WS_PORT --ws.api=net,eth --ws.origins=* --authrpc.port=$EL_RETH_1_AUTH_RPC_PORT --authrpc.jwtsecret=$JWT_PATH/jwtsecret --authrpc.addr=0.0.0.0 --metrics=0.0.0.0:$EL_RETH_1_METRICS_PORT --discovery.port=$EL_RETH_1_PORT --port=$EL_RETH_1_PORT > reth1.log
