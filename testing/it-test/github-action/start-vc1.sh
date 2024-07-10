#!/bin/bash
set -v on

CURRENT_DIR=$(cd $(dirname $0); pwd);
. $CURRENT_DIR/config.sh;

lighthouse vc --debug-level=info --testnet-dir=$CONFIGS_PATH --validators-dir=$NODE_0_KEYSTORES_PATH/keys --secrets-dir=$NODE_0_KEYSTORES_PATH/secrets --init-slashing-protection --beacon-nodes=http://$IP_ADDRESS:$CL_LIGHTHOUSE_1_HTTP_PORT --suggested-fee-recipient=0x8943545177806ED17B9F23F0a21ee5948eCaa776 --metrics --metrics-address=$IP_ADDRESS --metrics-allow-origin=* --metrics-port=$VC_LIGHTHOUSE_1_METRICS_PORT --graffiti=1-reth-lighthouse > vc1.log 2>&1



