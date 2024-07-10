#!/bin/bash

# Function to terminate all processes and exit
terminate_processes() {
  echo "Error occurred. Terminating all processes..."
  kill "${pids[@]}" >/dev/null 2>&1
  exit 1
}

# Set error trap
trap 'terminate_processes' ERR

# Function to check if historical sync success
assert_string_in_file() {
  local file_path=$1
  local search_string=$2

  if grep -q "$search_string" "$file_path"; then
    echo "Assertion passed: String found in the file."
    return 0
  else
    echo "Assertion failed: String not found in the file."
    return 1
  fi
}


#1.Config
./config.sh
./update_el_genesis_json.sh                   # Update time of genesis.json
./generate_validator_keystores.sh             # Generate keys

#2.Start producer 
duration=20m                                   # Set reth node duration time=20m

timeout $duration bash start-reth1.sh &
pids+=($!)
echo "start reth1"

timeout $duration bash start-reth2.sh &
pids+=($!)
echo "start reth2"

sleep 1m 
echo "sleep 1m"

bash generate_cl_genesis_ssz.sh &
pids+=($!)
echo "generate ssz"
sleep 30s

timeout $duration bash start-lighthouse1.sh &
pids+=($!)
echo "start lighthouse1"
timeout $duration bash start-lighthouse2.sh &
pids+=($!)
echo "start lighthouse2"
timeout $duration bash start-vc1.sh &
pids+=($!)
echo "start vc3"
timeout $duration bash start-vc2.sh &
pids+=($!)
echo "start vc4"

sleep 30s 

#3.Historical sync test
./historical1.sh  &
pids+=($!)
wait ${pids[-1]}
echo "after first historical sync"
# Check if historical1.sh execution failed
file_path="./his1.log"
search_string="Finished stage pipeline_stages=12/12"
assert_string_in_file "$file_path" "$search_string"

if [ $? -ne 0 ]; then
  terminate_processes
fi

#4.Historical sync test
./historical2.sh  &
pids+=($!)
echo "second historical sync"

# Check if historical2.sh execution failed
file_path="./his2.log"
search_string="Finished stage pipeline_stages=12/12"
assert_string_in_file "$file_path" "$search_string"

if [ $? -ne 0 ]; then
  terminate_processes
fi

#5.Send txs

#6.Call contract

#7. End
wait "${pids[@]}"
exit


