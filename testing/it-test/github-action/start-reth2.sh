#!/bin/bash
set -v on

CURRENT_DIR=$(cd $(dirname $0); pwd);
. $CURRENT_DIR/config.sh;

rm -rf $EL_RETH_2_DATA_PATH;
mkdir -p $EL_RETH_2_DATA_PATH;

while true ; do
	curl --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}' -H 'Content-Type: application/json' http://$IP_ADDRESS:${EL_RETH_1_HTTP_PORT};

	if [ $? -ne 0 ]; then
		sleep 30;
	else
		break;
	fi
done

reth1_node=$(curl --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}' -H 'Content-Type: application/json' http://$IP_ADDRESS:${EL_RETH_1_HTTP_PORT}\
           | jq .result.enode | sed -e "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/${IP_ADDRESS}/g" | sed 's/\"//g');
echo $reth1_node

reth node -vvv --datadir=$EL_RETH_2_DATA_PATH --chain=$CONFIGS_PATH/genesis.json --http --http.port=$EL_RETH_2_HTTP_PORT --http.addr=0.0.0.0 --http.corsdomain=* --http.api=admin,net,eth,web3,debug,trace --ws --ws.addr=0.0.0.0 --ws.port=$EL_RETH_2_WS_PORT --ws.api=net,eth --ws.origins=* --authrpc.port=$EL_RETH_2_AUTH_RPC_PORT --authrpc.jwtsecret=$JWT_PATH/jwtsecret --authrpc.addr=0.0.0.0 --metrics=0.0.0.0:$EL_RETH_2_METRICS_PORT --discovery.port=$EL_RETH_2_PORT --port=$EL_RETH_2_PORT --bootnodes=$reth1_node > reth2.log

