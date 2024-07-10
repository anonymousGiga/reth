#!/bin/bash

set -v on
CURRENT_DIR=$(cd $(dirname $0); pwd);
. $CURRENT_DIR/config.sh;

rm $BASE_DIR -rf
mkdir $BASE_DIR

# prepare network-args
cp  network-configs $BASE_DIR -rf

# JWT
mkdir -p ./jwt && \
openssl rand -hex 32 | tr -d "\n" | tee ./jwt/jwtsecret
cp jwt $BASE_DIR -rf && \

# Install eth2-val-tools
#git clone https://github.com/protolambda/eth2-val-tools.git && \
cd eth2-val-tools && \
git reset --hard 0d6d1ddb36479e73d7d876b29ac2d10ab3988e85 && \
go build -o eth2-val-tools main.go && \
cp eth2-val-tools ~/.cargo/bin && \

cd ../ && \

# Install eth2-testnet-genesis
#git clone  https://github.com/protolambda/eth2-testnet-genesis.git && \
cd eth2-testnet-genesis && \
git reset --hard 4b3498476f14b872b43080eee319adea45286daf && \
make && \
cp eth2-testnet-genesis ~/.cargo/bin && \

cd ../ &&\

# Install lighthouse 
#wget  https://github.com/sigp/lighthouse/releases/download/v5.2.1/lighthouse-v5.2.1-x86_64-unknown-linux-gnu.tar.gz && \
tar -zxvf lighthouse-v5.2.1-x86_64-unknown-linux-gnu.tar.gz && \
cp lighthouse  ~/.cargo/bin && \
lighthouse --version  


# Install reth
cd ../../../ && \
cargo build && \
cp ./target/debug/reth ~/.cargo/bin
echo "After build reth"




