#!/bin/bash

CURRENT_DIR=$(cd $(dirname $0); pwd);
. $CURRENT_DIR/config.sh;

current_time=$(date +%s%N | cut -b1-10);
genesis_time=$((current_time+10));
prague_time=$((genesis_time+38400000020));

sed -i "s/\(MIN_GENESIS_TIME: \)[0-9]*/\1$genesis_time/" $CONFIGS_PATH/config.yaml
sed -i "s/\"pragueTime\".*$/\"pragueTime\": ${prague_time}/" $CONFIGS_PATH/genesis.json;
sed -i "s/\"timestamp\".*$/\"timestamp\": \"${genesis_time}\"/" $CONFIGS_PATH/genesis.json;

