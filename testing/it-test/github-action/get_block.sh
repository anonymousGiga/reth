#!/bin/bash

# 设置变量
node_url="http://localhost:8545"  # 替换为你的节点 URL
block_number=1000                # 替换为你要查询的区块号
sleep_duration=30                  # 睡眠时间（秒）

block_hash=""
while [ -z "$block_hash" ] || [ "$block_hash" == "null" ]; do
    # 发送 HTTP 请求并获取区块数据
    response=$(curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["0x'$(printf "%x" $block_number)'", true],"id":1}' $node_url)
    
    # 解析区块哈希
    block_hash=$(echo $response | jq -r '.result.hash')
    
    if [ "$block_hash" == "null" ]; then
        echo "Failed to get block. Sleeping for $sleep_duration seconds..."
        sleep $sleep_duration
    fi
done

# 输出区块哈希
echo "Block Number: $block_number"
echo "Block Hash: $block_hash"
