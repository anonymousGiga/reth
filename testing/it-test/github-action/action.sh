#!/bin/bash

#1.Config
./config.sh
./update_el_genesis_json.sh                   # Update time of genesis.json
./generate_validator_keystores.sh             # Generate keys

##2.Start producer 
#duration=30m                                   # Set reth node duration time=30m
#
#timeout $duration bash start-reth1.sh &
#pids+=($!)
#echo "start reth1"
#
#timeout $duration bash start-reth2.sh &
#pids+=($!)
#echo "start reth2"
#
#sleep 1m 
#echo "sleep 1m"
#
#bash generate_cl_genesis_ssz.sh &
#pids+=($!)
#echo "generate ssz"
#sleep 30s
#
#timeout $duration bash start-lighthouse1.sh &
#pids+=($!)
#echo "start lighthouse1"
#timeout $duration bash start-lighthouse2.sh &
#pids+=($!)
#echo "start lighthouse2"
#timeout $duration bash start-vc1.sh &
#pids+=($!)
#echo "start vc3"
#timeout $duration bash start-vc2.sh &
#pids+=($!)
#echo "start vc4"
#
#sleep 30s 
#
##3.Historical sync test
#./historical1.sh  &
#pids+=($!)
#wait ${pids[-1]}
#echo "after first historical sync"
#
##4.Historical sync test
#./historical2.sh  &
#pids+=($!)
#echo "second historical sync"
#
##5.Send txs
#
##6.Call contract
#
##7. End
#wait "${pids[@]}"
#exit


