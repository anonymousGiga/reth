#!/bin/bash
set -v on

CURRENT_DIR=$(cd $(dirname $0); pwd);
. $CURRENT_DIR/config.sh;

rm -rf $CL_LIGHTHOUSE_2_DATA_PATH;
mkdir -p $CL_LIGHTHOUSE_2_DATA_PATH;

lighthouse1_enr=$(curl -1s http://$IP_ADDRESS:$CL_LIGHTHOUSE_1_HTTP_PORT/eth/v1/node/identity | jq -r '.data.enr');
echo $lighthouse1_enr

lighthouse beacon_node --debug-level=info --datadir=$CL_LIGHTHOUSE_2_DATA_PATH --disable-enr-auto-update --enr-address=$IP_ADDRESS --enr-udp-port=$CL_LIGHTHOUSE_2_ENR_UDP_PORT --enr-tcp-port=$CL_LIGHTHOUSE_2_ENR_TCP_PORT --listen-address=$IP_ADDRESS --port=$CL_LIGHTHOUSE_2_PORT --http --http-address=$IP_ADDRESS --http-port=$CL_LIGHTHOUSE_2_HTTP_PORT --http-allow-sync-stalled --slots-per-restore-point=32 --disable-packet-filter --execution-endpoints=http://$IP_ADDRESS:$EL_RETH_2_AUTH_RPC_PORT --jwt-secrets=$JWT_PATH/jwtsecret --suggested-fee-recipient=0x8943545177806ED17B9F23F0a21ee5948eCaa776 --subscribe-all-subnets --metrics --metrics-address=$IP_ADDRESS --metrics-allow-origin=* --metrics-port=$CL_LIGHTHOUSE_2_METRICS_PORT --enable-private-discovery --testnet-dir=$CONFIGS_PATH --boot-nodes=$lighthouse1_enr > lighthouse2.log 2>&1


