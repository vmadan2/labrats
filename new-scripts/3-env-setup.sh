#!/bin/bash
set -eu -o pipefail

#1-#9 are in new-steps1.sh file

#10. Before continuing, edit static-nodes.json file to add all nodes in the same order


#11. Start stuff: for each node, do: 
for i in {1..7}
do
	#11a. Copy raft$i/keystore/$(sudo ls raft$i/keystore) to qdata/node$i/keystore/acckey
	echo "$i. [*] Copying Ethereum Account Key from Raft to Qdata folder [*]"	
	sudo cp raft$i/keystore/$(sudo ls raft$i/keystore) qdata/node$i/keystore/acckey
	#11b. Copy raft$i/geth/nodekey to qdata/node$i/geth/nodekey
	echo "$i. [*] Copying Nodekey from Raft to Qdata [*]"
	cp raft$i/geth/nodekey qdata/node$i/nodekey	
	#11c. Copy raft$i/constellation.pub and constellation.key to qdata/c$i/keystore/
	echo "$i. [*] Copying Constellation Keys from Raft to Qdata [*]"
	cp raft$i/constellation_node_$i* qdata/c$i/keystore/	
	#11d. Copy raft$i/static-nodes.json to qdata/node$i/static-nodes.json
	echo "$i. [*] Copying Static Nodes from Raft to Qdata as Static and Permissioned Nodes [*]"
	sudo cp raft$i/static-nodes.json qdata/node$i/static-nodes.json
	sudo cp raft$i/static-nodes.json qdata/node$i/permissioned-nodes.json
	#11e. Initiate Geth
	echo "$i. [*] Initiate Geth [*]"
	geth --datadir qdata/node$i init genesis.json &	
#close loop for Step #11
done 

for i in {1..7}
do
	#11f. Initiate Constellation with conf command "constellation-node --url=https://127.0.0.$i:900$i/ --port=900$i --workdir=$DDIR --socket=tm.ipc --publickeys=tm.pub --privatekeys=tm.key 
	#	--othernodes=https://127.0.0.1:9001/".
	# --url=https://127.0.0.1:900$i/ --port=900$i --socket=$DDIR/tm.ipc --publickeys=$DDIR/keystore/constellation_node_$i.pub --privatekeys=$DDIR/keystore/constellation_node_$i.key --othernodes=https://127.0.0.1:900$i/
	#echo "$i [*] Initiating Constellation with Node $i Config [*]" 	
	DDIR="qdata/c$i"
	CMD="nohup constellation-node tm$i.conf"  #2>> qdata/logs/constellation.log &
	echo "$CMD >> qdata/logs/constellation$i.log 2>&1 &"
	$CMD 2>> qdata/logs/constellation$i.log & #>> "qdata/logs/constellation$i.log" 2>&1 &
done


DOWN=true
while $DOWN; do
    sleep 0.1
    DOWN=false
    for i in {1..7}
    do
	if [ ! -S "qdata/c$i/tm.ipc" ]; then
            DOWN=true
	fi
    done
done

for i in {1..7}
do
	#11g. Initiate geth for each node with "geth --datadir qdata/node$i init genesis.json"
	echo "$i [*] Initiating Geth with Node $i Config [*]" 
	ARGS="--nodiscover --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum --emitcheckpoints"
	PRIVATE_CONFIG=tm$i.conf nohup geth --datadir qdata/node$i $ARGS --raftport 2300$i --rpcport 2200$i --port 2100$i --unlock 0 --password password-file-$i.txt 2>>qdata/logs/geth$i.log &

#close loop for Step #11f
done


