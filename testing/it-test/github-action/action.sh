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
assert_pipeline_finished() {
  local file_path=$1

  if grep -qE 'Finished stage.*pipeline_stages.*12/12' "$file_path"; then
    echo "Assertion passed: Required line found in the file."
    return 0
  else
    echo "Assertion failed: Required line not found in the file."
    return 1
  fi
}



#1.Config
./config.sh
./update_el_genesis_json.sh                   # Update time of genesis.json
./generate_validator_keystores.sh             # Generate keys

#2.Start producer 
duration=5m                                   # Set reth node duration time=20m

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
sleep 10s

timeout $duration bash start-lighthouse1.sh &
pids+=($!)
sleep 5s
echo "start lighthouse1"
timeout $duration bash start-lighthouse2.sh &
pids+=($!)
sleep 5s
echo "start lighthouse2"
timeout $duration bash start-vc1.sh &
pids+=($!)
echo "start vc1"
sleep 5s
timeout $duration bash start-vc2.sh &
pids+=($!)
echo "start vc2"
sleep 5s

#3.Historical sync test
timeout $duration ./historical1.sh  &
pids+=($!)
wait ${pids[-1]}
echo "after first historical sync"
# Check if historical1.sh execution failed
file_path="./his1.log"
assert_pipeline_finished "$file_path"

if [ $? -ne 0 ]; then
  terminate_processes
fi

#4.Historical sync test
timeout $duration ./historical2.sh  &
pids+=($!)
echo "second historical sync"

# Check if historical2.sh execution failed
file_path="./his2.log"
assert_pipeline_finished "$file_path"

if [ $? -ne 0 ]; then
  terminate_processes
fi

#5.Send txs

#6.Call contract

#7. End
wait "${pids[@]}"

file_path="./his1.log"
assert_pipeline_finished "$file_path"
file_path="./his2.log"
assert_pipeline_finished "$file_path"

exit


