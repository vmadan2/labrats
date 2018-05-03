#!/bin/bash
set -eu -o pipefail

cat raft1/static-nodes.json
cat raft2/static-nodes.json
cat raft3/static-nodes.json
cat raft4/static-nodes.json
cat raft5/static-nodes.json
cat raft6/static-nodes.json
cat raft7/static-nodes.json

for i in {1..7}
do 
	if [ $i -eq 1 ]  
	then
		echo "[\"$(cat raft$i/static-nodes.json | grep -oEim 1 '(enode.*@)')127.0.0.1:2100$i?discport=0&raftport=2300$i\"," > raft1/static-nodes.json
	elif [[ $i -gt 1 ]] &&  [[ $i -lt 7 ]] 
	then
		echo "\"$(cat raft$i/static-nodes.json | grep -oEim 1 '(enode.*@)')127.0.0.1:2100$i?discport=0&raftport=2300$i\"," >> raft1/static-nodes.json
	else
		echo "\"$(cat raft$i/static-nodes.json | grep -oEim 1 '(enode.*@)')127.0.0.1:2100$i?discport=0&raftport=2300$i\"]" >> raft1/static-nodes.json
	fi
done


sudo cp raft1/static-nodes.json raft2/static-nodes.json
sudo cp raft1/static-nodes.json raft3/static-nodes.json
sudo cp raft1/static-nodes.json raft4/static-nodes.json
sudo cp raft1/static-nodes.json raft5/static-nodes.json
sudo cp raft1/static-nodes.json raft6/static-nodes.json
sudo cp raft1/static-nodes.json raft7/static-nodes.json

cat raft1/static-nodes.json
cat raft2/static-nodes.json
cat raft3/static-nodes.json
cat raft4/static-nodes.json
cat raft5/static-nodes.json
cat raft6/static-nodes.json
cat raft7/static-nodes.json

