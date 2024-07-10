#!/bin/bash
set -v on

CURRENT_DIR=$(cd $(dirname $0); pwd);

. $CURRENT_DIR/config.sh;

rm -rf $KEYSTORE_PATH;
mkdir -p $KEYSTORE_PATH;


# 下面两行生成keystore脚本中，--source-min --source-max配置是不一样的
eth2-val-tools keystores --insecure --out-loc $NODE_0_KEYSTORES_PATH --source-mnemonic "giant issue aisle success illegal bike spike question tent bar rely arctic volcano long crawl hungry vocal artwork sniff fantasy very lucky have athlete" --source-min 0 --source-max 64; 
 
eth2-val-tools keystores --insecure --out-loc $NODE_1_KEYSTORES_PATH --source-mnemonic "giant issue aisle success illegal bike spike question tent bar rely arctic volcano long crawl hungry vocal artwork sniff fantasy very lucky have athlete" --source-min 64 --source-max 128;


