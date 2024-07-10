#!/bin/bash

set -v on

CURRENT_DIR=$(cd $(dirname $0); pwd);
. $CURRENT_DIR/config.sh;

while true ; do
	curl --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}' -H 'Content-Type: application/json' http://$IP_ADDRESS:${EL_RETH_1_HTTP_PORT};

	if [ $? -ne 0 ]; then
		sleep 1;
	else
		break;
	fi
done

reth1_node=$(curl --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}' -H 'Content-Type: application/json' http://$IP_ADDRESS:${EL_RETH_1_HTTP_PORT}\
           | jq .result.enode | sed -e "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/${IP_ADDRESS}/g" | sed 's/\"//g');
echo $reth1_node

BLOCK_NUMBER=15
TIP=""
while [ -z "$TIP" ] || [ "$TIP" == "null" ]; do
	RES=$(curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["0x'$(printf "%x" $BLOCK_NUMBER)'", true],"id":1}' http://$IP_ADDRESS:${EL_RETH_1_HTTP_PORT})
	TIP=$(echo $RES | jq -r '.result.hash')

	if [ "$TIP" == "null" ]; then
            echo "Failed to get block. Sleeping for $sleep_duration seconds..."
            sleep 30s
        fi

done

echo "Block Number: $BLOCK_NUMBER"
echo "Block Hash: $TIP"

reth node -vvv --datadir=$EL_HISTORICAL_SYNC_DATA_PATH --chain=$CONFIGS_PATH/genesis.json --http --http.port=$EL_RETH_SYNC_HTTP_PORT --authrpc.port=$EL_RETH_SYNC_AUTH_RPC_PORT --discovery.port=$EL_RETH_SYNC_PORT --port=$EL_RETH_SYNC_PORT --debug.tip $TIP --bootnodes=$reth1_node --debug.terminate > his2.log

echo "after historical sync --------------------------------------------------------------------------------------------------------------------"
