#!/bin/bash
set -u
set -e



for i in {1..5}
do
	echo " ******Configuring Constellation Node $i****** "
	echo "[*] Cleaning up temporary data directories for Node $i"
	rm -rf raft$i
	mkdir raft$i
	echo "[*] Generating geth node config"
	nohup geth --datadir raft 2>> raft/setup.log &
	sleep 3
	echo "[\"$(cat raft/setup.log | grep -oEi '(enode.*@)')127.0.0.1:21000?discport=0&raftport=23000\"]" >> raft/static-nodes.json
	DDIR="qdata/c$i"
	mkdir -p $DDIR
	cd $DDIR; constellation-node --generatekeys=constellation 
	rm -f "$DDIR/tm$i.ipc"
	echo "nohup constellation-node tm$i.conf 2>> qdata/logs/constellation$i.log &" 
	nohup constellation-node tm.conf 2>> qdata/logs/constellation$i.log &
done














#!/bin/bash
set -u
set -e

echo " ******Configuring Constellation Node 1****** "
echo "[*] Cleaning up temporary data directories"
rm -rf raft
mkdir raft

echo "[*] Generating geth node config"
nohup geth --datadir raft 2>> raft/setup.log &
sleep 3
echo "[\"$(cat raft/setup.log | grep -oEi '(enode.*@)')127.0.0.1:21000?discport=0&raftport=23000\"]" >> raft/static-nodes.json

echo "[*] Creating default ethereum account"
geth --datadir raft --password passwords.txt account new

echo "[*] Stopping geth"
killall geth

echo "[*] Generating constellation key pair"
cd raft
constellation-node --generatekeys=constellation

echo "[*] Done Node 1"

echo " ******Configuring Constellation Node 2****** "




mkdir -p qdata/logs



